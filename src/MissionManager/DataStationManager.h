
#include <QList>
#include <QStandardPaths>
#include <QFile>
#include <QIODevice>
#include <QJsonDocument>
#include <QSaveFile>
#include <QDebug>

#include "QGCApplication.h"
#include "QGCToolbox.h"

#include "DataStationLink.h"
#include "DataStation.h"

class DataStationManager : public QGCTool
{
Q_OBJECT
Q_PROPERTY(QList<DataStation*> dataStations READ getDataStations NOTIFY dataStationsChanged)

private:

    DataStationLink * _dsLink;
    QList<DataStation *> dataStations;

public:

    DataStationManager(QGCApplication *app, QGCToolbox *toolbox);
    // close _dsLink
    ~DataStationManager();

    // Initialize _dsLink
    Q_INVOKABLE void connect(QString portname);

    // initialize datastation, give it a new ID, returns ID
    QString initializeDS();

    // get datastation's coordinates, mark as deployed
    void deployDS(QString targetId);


    Q_INVOKABLE void toggleActive(int index);

    void loadFromFile();
    void saveToFile();
    // remove datastation from list?
    // void removeDS(QString targetId);

    Q_INVOKABLE QGeoCoordinate getCoordinate(int index);
    Q_INVOKABLE double getLat(int index){ return dataStations.value(index)->getLat(); }
    Q_INVOKABLE double getLon(int index){ return dataStations.value(index)->getLon(); }
    Q_INVOKABLE QString getId(int index){ return dataStations.value(index)->getId(); }
    Q_INVOKABLE void deleteStation(int index);
    Q_INVOKABLE bool isActive(int index){ return dataStations.value(index)->getActive(); }
    Q_INVOKABLE void setActive(int index, bool status){ dataStations.value(index)->setActive(status); }
    Q_INVOKABLE int getNumOfDataStations(){ return dataStations.size(); }

signals:
    void dataStationsChanged();
};



