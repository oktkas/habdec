#include "sondehub_uploader.h"

#include <iostream>
#include <cmath>
#include <boost/algorithm/string.hpp>
#include "common/utc_now_iso.h"
#include "common/git_repo_sha1.h"
#include "common/json.hpp"
#include <cpr/cpr.h>

namespace sondehub
{


void SondeHubUploader::push(const MinTelemetry& t)
{
    if(api_endpoint_ == "" || uploader_callsign_ == "")
        return;

    std::lock_guard<std::mutex> _lock(queue_mtx_);
    queue_.push_back(t);
}


size_t SondeHubUploader::size() const
{
    std::lock_guard<std::mutex> _lock(queue_mtx_);
    return queue_.size();
}


void SondeHubUploader::upload(bool extra_fields)
{
    if(api_endpoint_ == "" || uploader_callsign_ == "")
        return;

    processing_queue_.clear();

    {
        std::lock_guard<std::mutex> _lock(queue_mtx_);
        if(!queue_.size())
            return;
        queue_.swap(processing_queue_);
    }

    using namespace std;

    const string utc_now_str = utc_now_iso();
    stringstream s;
    s<<"[";

    for(auto& t : processing_queue_) {
       	using json = nlohmann::json;
        json tele_json;

        tele_json["uploader_callsign"] = uploader_callsign_;
        tele_json["software_name"] = "habdec";
        tele_json["software_version"] = string(g_GIT_SHA1).substr(0,7);
        tele_json["time_received"] = t.time_received;
        tele_json["upload_time"] = utc_now_str;
        tele_json["payload_callsign"] = t.payload_callsign;
        tele_json["datetime"] = t.datetime;
        tele_json["frame"] = t.frame;
        tele_json["lat"] = t.lat;
        tele_json["lon"] = t.lon;
        tele_json["alt"] = static_cast<int>(t.alt);
        tele_json["raw"] = t.raw;
        if (t.frequency > 0.0f)
            tele_json["frequency"] = t.frequency;
        if (extra_fields) {
            if (!std::isnan(t.batt))
                tele_json["batt"] = std::round(t.batt * 100.0f) / 100.0f;
            if (!std::isnan(t.temp))
                tele_json["temp"] = std::round(t.temp * 10.0f) / 10.0f;
            if (!std::isnan(t.humidity))
                tele_json["humidity"] = static_cast<int>(std::round(t.humidity));
            if (t.sats >= 0)
                tele_json["sats"] = t.sats;
        }
        tele_json["modulation"] = "RTTY";
        if (!modulation_detail_.empty())
            tele_json["modulation_detail"] = modulation_detail_;
        if (station_lat_ != 0.0f || station_lon_ != 0.0f)
            tele_json["uploader_position"] = std::vector<float>{station_lat_, station_lon_, station_alt_};

        s<<tele_json<<",";

    }

    string payload{s.str()};
    payload.at(payload.size()-1) = ']';

    // cout<<payload<<endl;
    // cout<<"uploading to "<<api_endpoint_<<endl;
    // return;

    cpr::Response r = cpr::Put(
				cpr::Url{api_endpoint_},
				cpr::Body{payload},
				cpr::Header{
					{"User-Agent", "habdec"},
					{"Content-Type", "application/json"}
				}
			);

    if(r.status_code != 200) {
        cout<<"sondehub upload error:\n";
        cout<<r.status_code<<endl;                  // 200
        cout<<r.header["content-type"]<<endl;       // application/json; charset=utf-8
        cout<<r.text<<endl;
    }
}


}