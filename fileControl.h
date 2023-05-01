#ifndef FILECONTROL_H
#define FILECONTROL_H

#include <QString>
#include <QQueue>

class FileControl
{
public: 
    FileControl();

    bool setPathFile(const QString _partFile);
    QQueue<QString> readFile();

private:
    QString m_pathFile;

    bool isNumberLine(const QString line);
};

#endif // FILECONTROL_H
