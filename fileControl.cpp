#include "fileControl.h"
#include <QFileInfo>
#include <QString>
#include <QDebug>

FileControl::FileControl()
{

}

bool FileControl::setPathFile(const QString _partFile)
{
    bool result = false;
    QFileInfo check_file(_partFile);
    if (check_file.exists() && check_file.isFile()) {
        result = true;
        m_pathFile = _partFile;
    }
    return result;
}

QQueue<QString> FileControl::readFile()
{
    QQueue<QString> resultReadFile;

    if (m_pathFile.isEmpty())
        return resultReadFile;

    QFile file(m_pathFile);
    if(file.open(QIODevice::ReadOnly |QIODevice::Text))
    {
        while(!file.atEnd())
        {
            //QString str = file.readLine();
            QString str = QString::fromUtf8(file.readLine()).remove("\r").remove("\n");
            if (isNumberLine(str))
                resultReadFile.enqueue(str);
        }
    }
    else
        qWarning()<< "Don't open file: "<<m_pathFile;

    return resultReadFile;
}

bool FileControl::isNumberLine(const QString line)
{
    //Жестких требований к числовой строке не было указано в ТЗ
    //В моем понимании числовая строка это строка содержащее число
    //или несколько чисел разделенных пробелом

    bool result = true;
    QStringList words = line.split(' ');

    foreach (QString word, words) {
        word.replace(',','.');
        bool toInt, toDouble, toFloat;
        word.toInt(&toInt);
        word.toDouble(&toDouble);
        word.toFloat(&toFloat);

        if (!(toInt || toDouble || toFloat)){
            result = false;
            break;
        }
    }

    return result;
}

