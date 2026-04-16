#pragma once

#include <string>
#include <vector>
#include <mutex>

namespace sondehub
{

// minimal telemetry
struct MinTelemetry
{
    std::string payload_callsign;
    std::string time_received;
    std::string datetime;
    int frame;
    float lat;
    float lon;
    float alt;
    std::string raw;
    float frequency = 0.0f;  // MHz; 0 means not set
};

class SondeHubUploader
{
private:
    std::vector<MinTelemetry>   queue_;
	mutable std::mutex          queue_mtx_;

    std::vector<MinTelemetry>   processing_queue_;

    std::string api_endpoint_;
    std::string uploader_callsign_;
    float station_lat_ = 0.0f;
    float station_lon_ = 0.0f;
    float station_alt_ = 0.0f;
    std::string modulation_detail_;
    std::string uploader_antenna_;

public:
    SondeHubUploader(
        const std::string& api_endpoint,
        const std::string& uploader_callsign,
        float station_lat = 0.0f,
        float station_lon = 0.0f,
        float station_alt = 0.0f,
        const std::string& modulation_detail = "",
        const std::string& uploader_antenna = "")
        : api_endpoint_(api_endpoint)
        , uploader_callsign_(uploader_callsign)
        , station_lat_(station_lat)
        , station_lon_(station_lon)
        , station_alt_(station_alt)
        , modulation_detail_(modulation_detail)
        , uploader_antenna_(uploader_antenna)
    {};
    void push(const MinTelemetry&);
    void upload();
    size_t size() const;

};

}