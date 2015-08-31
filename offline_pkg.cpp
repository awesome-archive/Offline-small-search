#include "offline_pkg.h"

offline_pkg::offline_pkg(QObject *parent) : QObject(parent)
{
    zim_exist = false;
    img.setPattern("[\"'\\(](pic.*)[\"'\\)]");
    img.setMinimal(true);
    img.setCaseSensitivity(Qt::CaseInsensitive);
}

offline_pkg::~offline_pkg()
{
    if(zim_exist)
    {
        delete zim_file;
        zim_exist = false;
    }
}

QString offline_pkg::type() const
{
    return m_type;
}

void offline_pkg::setType(const QString & type)
{
    m_type = type;
    Q_EMIT typeChanged(m_type);
}

QString offline_pkg::path() const
{
    return m_path;
}

void offline_pkg::setPath(const QString & path)
{
    m_path = path;
    Q_EMIT pathChanged(m_path);
    if(zim_exist)
    {
        delete zim_file;
        zim_exist = false;
    }
    if(QFile::exists(QString(path+"/data.zim")))
    {
        try{
            zim_file = new zim::File(QString(path+"/data.zim").toStdString());
            zim_exist = true;
        }
        catch(...) {zim_exist = false;}
    }
}

QString offline_pkg::name() const
{
    return m_name;
}

void offline_pkg::setName(const QString & name)
{
    m_name = name;
    Q_EMIT nameChanged(m_name);
}

QString offline_pkg::name_code() const
{
    return m_name_code;
}

void offline_pkg::setName_code(const QString & name_code)
{
    m_name_code = name_code;
    Q_EMIT name_codeChanged(m_name_code);
}

QString offline_pkg::count() const
{
    return m_count;
}

void offline_pkg::setCount(const QString & count)
{
    m_count = count;
    Q_EMIT countChanged(m_count);
}

bool offline_pkg::enable() const
{
    return m_enable;
}

void offline_pkg::setEnable(const bool & enable)
{
    m_enable = enable;
    Q_EMIT enableChanged(m_enable);
}

QString offline_pkg::get_text_from_url(QString & url)
{
    if(!zim_exist) return "";
    try{
        auto it = zim_file->findx("A/"+url.toStdString());
        if(m_type == "ST")
        {
            it = zim_file->findx("A/"+url.toUpper().toStdString()+".html");
            if (!it.first)
            {
                it = zim_file->findx("A/"+url.toUpper().toStdString()+".HTML");
                if (!it.first)
                {
                    it = zim_file->findx("A/"+url.toUpper().toStdString());
                    if (!it.first)
                    {
                        it = zim_file->findx("A/"+url.toStdString());
                    }
                }
            }
        }

        if(it.first)
        {
            if (it.second->isRedirect())
              return QString::fromStdString(std::string(it.second->getRedirectArticle().getData().data(), it.second->getRedirectArticle().getData().size()));
            else
              return QString::fromStdString(std::string(it.second->getData().data(), it.second->getData().size()));
        }
        else return "";
    }
    catch(...) {return "";}
}

QString offline_pkg::get_text_with_other_from_url(QString & url, QString &cache_dir)
{
    if(!zim_exist) return "";
    try{
        auto it = zim_file->findx("A/"+url.toStdString());
        if(m_type == "ST")
        {
            it = zim_file->findx("A/"+url.toUpper().toStdString()+".html");
            if (!it.first)
            {
                it = zim_file->findx("A/"+url.toUpper().toStdString()+".HTML");
                if (!it.first)
                {
                    it = zim_file->findx("A/"+url.toUpper().toStdString());
                    if (!it.first)
                    {
                        it = zim_file->findx("A/"+url.toStdString());
                    }
                }
            }
        }

        if(it.first)
        {
            if (it.second->isRedirect())
              str = QString::fromStdString(std::string(it.second->getRedirectArticle().getData().data(), it.second->getRedirectArticle().getData().size()));
            else
              str =  QString::fromStdString(std::string(it.second->getData().data(), it.second->getData().size()));
        }
        else return "";

        int pos = 0;
        while ((pos = img.indexIn(str, pos)) != -1)
        {
            it = zim_file->findx("A/"+img.cap(1).replace(QRegExp("[/\\\\]{2,}"),"/").toStdString());
            img_file.setFileName(cache_dir+img.cap(1));
            fileinfo.setFile(img_file);
            dir.mkpath(fileinfo.absolutePath());
            if (it.first)
            {
                if (it.second->isRedirect())
                {
                    img_file.open(QFile::ReadWrite);
                    img_file.write(it.second->getRedirectArticle().getData().data(), it.second->getRedirectArticle().getData().size());
                    img_file.close();
                }
                else
                {
                    img_file.open(QFile::ReadWrite);
                    img_file.write(it.second->getData().data(), it.second->getData().size());
                    img_file.flush();
                    img_file.close();
                }
            }
            pos += img.matchedLength();
        }
        //str.replace("\"pic",("\"file:///"+cachedir+"pic")).replace("(pic",("(file:///"+cachedir+"pic")).replace("'pic",("'file:///"+cachedir+"pic"));
        return str;
    }
    catch(...) {return "";}
}