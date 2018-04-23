#include "DataStation.h"

DataStation::DataStation()
{
    id = "01";
    lon = -1;
    lat = -1;
    active=false;
}

DataStation::DataStation(const DataStation &other)
{
    id = other.getId();
    lat = other.getLat();
    lon = other.getLon();
    active = other.getActive();
}

void DataStation::setId(QString newId){
    id = newId;
}

void DataStation::setLat(double newLat){
    lat = newLat;
}
void DataStation::setLon(double newLon){
    lon = newLon;
}

double DataStation::getLat() const{
    return lat;
}

double DataStation::getLon() const{
    return lon;
}

QString DataStation::getId() const{
    return id;
}

void DataStation::setActive(bool newActive){
    active = newActive;
}

bool DataStation::getActive() const{
    return active;
}

void DataStation::toggleActive(){
    active = !active;
}


