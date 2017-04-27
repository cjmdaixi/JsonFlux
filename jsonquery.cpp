#include "jsonquery.h"
#include "jsondatabase.h"
#include <QtDebug>
#include <QRegularExpression>
#include <QRegularExpressionMatch>
#include <QJsonValue>
#include <QVariantMap>

JsonQuery::JsonQuery(QObject *parent)
    : QObject(parent)
{
    connect(database(), &JsonDatabase::updated, this, &JsonQuery::onModelUpdated);
}

JsonQuery::~JsonQuery()
{
}

QString JsonQuery::model() const
{
    return m_model;
}

void JsonQuery::setModel(QString newModel)
{
    if(m_model == newModel) return;

    m_model = newModel;
    emit modelChanged();
}

QStringList JsonQuery::query() const
{
    return m_query;
}

void JsonQuery::setQuery(QStringList newQuery)
{
    if(m_query == newQuery) return;

    m_query = newQuery;

    emit valuesChanged();
    emit queryChanged();
}

QVariantMap JsonQuery::values() const
{
    QVariantMap results;

    auto modelObject = database()->model(m_model);
    if(modelObject == Q_NULLPTR)
        return results;

    QRegularExpression re("^(?<node>\\w+)(\\[(?<idx>\\d*)\\])?$");
    for(int i = 0; i != m_query.size(); ++i){
        auto &oneQuery = m_query[i];
        auto nodeList = oneQuery.split('.');
        QJsonValue jsonVal = modelObject->jsonObject();
        auto foundNode = true;
        for(auto &node : nodeList){
            if(!jsonVal.isObject()){
                qDebug()<<"the json value is not an object!";
                foundNode = false;
                break;
            }
            auto jsonObj = jsonVal.toObject();

            auto match = re.match(node);
            if(!match.hasMatch()){
                qDebug()<<"invalid node name!";
                foundNode = false;
                break;
            }
            auto nodeName = match.captured("node");
            auto nodeIdx = match.captured("idx");
            if(!jsonObj.contains(nodeName)){
                qDebug()<<"no such node"<<nodeName;
                foundNode = false;
                break;
            }
            jsonVal = jsonObj[nodeName];
            if(nodeIdx != ""){
                if(!jsonVal.isArray()){
                    qDebug()<<"the node is not an array!";
                    foundNode = false;
                    break;
                }
                auto idx = nodeIdx.toInt();
                jsonVal = jsonVal.toArray()[idx];
            }
        }
        if(foundNode){
            results[oneQuery] = jsonVal.toVariant();
            results[QString("@%1").arg(i)] = jsonVal.toVariant();
        }
    }

    return results;
}

bool JsonQuery::enabled() const
{
    return m_enabled;
}

void JsonQuery::setEnabled(bool newEnabled)
{
    if(m_enabled == newEnabled) return;

    m_enabled = newEnabled;

    if(m_enabled){
        connect(database(), &JsonDatabase::updated, this, &JsonQuery::onModelUpdated);
    }else{
        disconnect(database(), &JsonDatabase::updated, this, &JsonQuery::onModelUpdated);
    }

    emit enabledChanged();
}

void JsonQuery::onModelUpdated(QString modelName)
{
    if(m_model == modelName)
        emit valuesChanged();
}
