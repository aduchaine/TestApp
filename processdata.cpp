#include <QDebug>
#include <fstream> // std::ofstream
#include <iostream>
#include <sys/stat.h>
#include <sys/types.h> // possibly for UNIX MakeDirectory
#include <direct.h>
#include <ctime>

#include "processdata.h"
#include "uiprocess.h"
#include "datacodes.h"


std::ofstream user_file_stream;
std::ifstream iuser_file_stream;

std::vector<std::string> file_data;
std::vector<std::string> directory_vec;
std::vector<int> special_field_vec = { 10 }; // fieldID #'s whose answers require special formatting procedures - add ot this when needed

const char * new_ErrorLog = "\n\n\t*** New ERROR log files are generated automatically on a monthly interval."
                            "\n\t*** The purpose of this file is to help identify issues."
                            "\n\t*** Each log entry is headed by a date/time stamp."
                            "\n\t*** The first entry is the date of creation.\n";
const char * new_SessionLog = "\n\n\t*** New SESSION log files are generated automatically on a monthly interval."
                              "\n\t*** Many different actions from the user or the processes can be recorded for analysis."
                              "\n\t*** Each log entry is headed by a date/time stamp."
                              "\n\t*** The first entry is the date of creation."
                              "\n\t*** A minimal log system exists which will show when a user performs two distinct actions."
                              "\n\t*** An entry will be created when the user successfully enters a full name."
                              "\n\t*** An entry will be created when the user voluntarily exits the program.\n";


ProcessData::ProcessData()
{

}

void ProcessData::PrepareUIData()
{
    GetDirectories();

    DataCodes DC;
    DC.PrepareFileData();
    DC.LoadFieldData();

    qDebug() << "\t\t...file data successfully moved to internal memory.";
}

void ProcessData::GetDirectories()
{
    std::string directory;

    for (unsigned int i = 0; i < FileDirectories::MaxDirectoryID; ++i) {
        directory = DirectoryString[i];
        directory_vec.push_back(directory);
        //QString q_dir = QString::fromStdString(directory);
        //qDebug() << "dir: " << q_dir;
    }
}

void ProcessData::TimeStamp(char * time_stamp)
{
    time_t raw_time;
    struct tm * time_info;
    time(&raw_time);
    time_info = localtime(&raw_time);
    strftime(time_stamp, 80, "[%m-%d-%Y :: %H:%M:%S]", time_info);
}

const std::string ProcessData::StringFormat(const char * format, ...)
{
    va_list args;
    va_start(args, format);
    std::string output = vStringFormat(format, args);
    va_end(args);
    return output;
}

const std::string ProcessData::vStringFormat(const char * format, va_list args)
{
    std::string output;
    va_list tmpargs;

    va_copy(tmpargs, args);
    int characters_used = vsnprintf(nullptr, 0, format, tmpargs);
    va_end(tmpargs);

    if (characters_used > 0) {
        output.resize(characters_used + 1);

        va_copy(tmpargs, args);
        characters_used = vsnprintf(&output[0], output.capacity(), format, tmpargs);
        va_end(tmpargs);

        output.resize(characters_used);

        if (characters_used < 0)
            output.clear();
    }
    return output;
}

void ProcessData::MakeDirectory(const std::string &directory_name)
{
    struct _stat st;
#if defined _WIN32
    //struct _stat st;
    if (_stat(directory_name.c_str(), &st) == 0) { // exists
        qDebug() << "\n\t\tERROR: directory already exists";
        return;
    }
    _mkdir(directory_name.c_str());
#else
    mode_t nMode = 0733; // UNIX style permissions
    if (_stat(directory_name.c_str(), &st) == 0) { // exists
        qDebug() << "\n\t\tERROR: directory already exists";
        return;
    }
    mkdir(sPath.c_str(), nMode);
#endif
}

void ProcessData::CreateDirectories()
{

    MakeDirectory("C:/MyProgram/");    
    MakeDirectory("C:/MyProgram/Documents/");
    MakeDirectory("C:/MyProgram/Documents/User_data/");    
    MakeDirectory("C:/MyProgram/Logs/");
    MakeDirectory("C:/MyProgram/Logs/Error/");
    MakeDirectory("C:/MyProgram/Logs/User/");
    MakeDirectory("C:/MyProgram/TestApp/");
    MakeDirectory("C:/MyProgram/TestApp/Batch_files/");
    MakeDirectory("C:/MyProgram/TestApp/Form/");
    MakeDirectory("C:/MyProgram/TestApp/Install/");
    MakeDirectory("C:/MyProgram/DataFiles/");
    MakeDirectory("C:/MyProgram/DataFiles/Lists/");
    MakeDirectory("C:/MyProgram/DataFiles/Prompts/");
    MakeDirectory("C:/MyProgram/DataFiles/Responses/");

}

// pass the directory from <CheckFileTime()> to open where needed - NOT HERE
void ProcessData::CheckFiles()
{
    if (CheckFileTime((directory_vec.at(ERROR_LOG)), true) == false) {
        ErrorLog(new_ErrorLog);
    }

    if (CheckFileTime(directory_vec.at(SESSION_LOG), true) == false) {
        SessionLog(new_SessionLog);
    }

}

void ProcessData::FileTime(char * time_stamp)
{
    time_t raw_time;
    struct tm * time_info;
    time(&raw_time);
    time_info = localtime(&raw_time);
    strftime(time_stamp, 80, "%Y-%m", time_info);
}

// check if file exists - if exists change passed name(p_filename) - a replica function could be created to increase file options
std::string ProcessData::CheckOutputFile(std::string p_filename)
{
    // do this quick because there is likely no file
    // having both in does nothing to change how it works
    // only one of these is needed if both files are created and both filenames have not been altered

    // option for a TEXT file

    //  std::string tar_directory = StringFormat("%s/%s.txt", directory_vec.at(USER_DATA_FOLDER).c_str(), p_filename.c_str());
    //  if (FileOpen(tar_directory, READ) == false) {
    //      return p_filename;
    //  }
    // option for MS Word document

    std::string wtar_directory = StringFormat("%s/%s.docx", directory_vec.at(WORD_DOC_FOLDER).c_str(), p_filename.c_str());
    if (FileOpen(wtar_directory, READ) == false) {
        return p_filename;
    }

    std::string filename;
    std::string s_int;
    unsigned int i;

    for (i = 1; i < 100; i++) {
        filename = p_filename;
        s_int = std::to_string(i);
        filename.append("(" + s_int + ")");

        //tar_directory = StringFormat("%s/%s.txt", directory_vec.at(WORD_DOC_FOLDER).c_str(), filename.c_str());

        wtar_directory = StringFormat("%s/%s.docx", directory_vec.at(WORD_DOC_FOLDER).c_str(), filename.c_str());

        QString q_username = QString::fromStdString(filename);
        qDebug() << "mod filname: " << q_username;

        // text file option
        //  if (FileOpen(tar_directory, READ) == false) {
        //      break;
        //  }
        // MS Word option
        if (FileOpen(wtar_directory, READ) == false) {
            break;
        }
    }
    return filename;
}

// checks on startup how the log files will open - either a new file or open existing
bool ProcessData::CheckFileTime(std::string tar_directory, bool startup)
{
    bool exists = false;

    std::string::size_type sz;
    unsigned int i;
    int i_time_increment;
    int i_time;
    std::string s_int;
    std::string s_time_stamp;
    std::string time_increment; // set to one month
    std::string m_tar_directory;
    const char * mc_filename2;

    char time_stamp[80];
    FileTime(time_stamp);

    const char * mc_filename = time_stamp;

    // if a portion of the log file name is == "time_increment" -> open for reading on startup else open to append
    // else create a new log file with a portion of the log file name == "time_increment"
    s_time_stamp = time_stamp;
    time_increment = s_time_stamp.substr(5, 2);
    i_time_increment = stoi(time_increment, &sz);

    if (startup == true) {
        for (i = i_time_increment; i < 12; i--) {
            s_int = std::to_string(i);

            if (strlen(s_int.c_str()) == 1) {
                s_int = "0" + s_int;
                s_time_stamp.replace(5, 2, s_int);
            }
            else {
                s_time_stamp.replace(5, 2, s_int);
            }

            mc_filename2 = s_time_stamp.c_str();
            i_time = stoi(s_int, &sz);
            m_tar_directory = StringFormat("%s_%s.txt", tar_directory.c_str(), mc_filename2);

            if (i_time_increment == i_time && FileOpen(m_tar_directory, READ) == true) {
                exists = true;
                break;
            }
        }
        // else create a new log file
        if (exists == false) {
            m_tar_directory = StringFormat("%s_%s.txt", tar_directory.c_str(), mc_filename);
            FileOpen(m_tar_directory, CREATE);
        }
    }
    else {
        m_tar_directory = StringFormat("%s_%s.txt", tar_directory.c_str(), mc_filename);
        FileOpen(m_tar_directory, APPEND);
    }
    return exists;
}

// should make append a variable instead of the norm - it isn't the norm, overwriting is
bool ProcessData::FileOpen(std::string tar_directory, int open_status)
{
    if (iuser_file_stream.is_open()) {
        iuser_file_stream.close();
    }
    if (user_file_stream.is_open()) {
        user_file_stream.close();
    }

    bool valid = false;

    // in case it's messed up - this goes in CREATE as first conditional
    if (open_status == CREATE) {
         if (std::ifstream(tar_directory)) {
             qDebug() << "File already exists";
             return valid;
        }
    }
    // this goes in all others as first conditional
    else if (!(std::ifstream(tar_directory))) {
        qDebug() << "\n\t\tFile does not exist";
        return valid;
    }

    switch (open_status) {
    case READ:
        iuser_file_stream.open(tar_directory, std::ios_base::out | std::fstream::in);
        qDebug() << "\n\t\t...file successfully opened for reading.";
        valid = true;
        break;
    case CREATE:
        user_file_stream.open(tar_directory, std::ios_base::out | std::ios_base::app);
        qDebug() << "\n\t\t...file successfully created, ready to write.";
        valid = true;
        break;
    case APPEND:    
        user_file_stream.open(tar_directory, std::ios_base::app | std::ios_base::out);
        qDebug() << "\n\t\t...file successfully opened to append.";
        valid = true;
        break;
    case TRUNCATE:    
        user_file_stream.open(tar_directory, std::ios::trunc);
        qDebug() << "\n\t\t...file successfully truncated, ready to write.";
        valid = true;
        break;
    default:     
        user_file_stream.open(tar_directory, std::ios_base::in | std::ios_base::out);
        qDebug() << "\n\t\t...file successfully opened to overwrite.";
        valid = true;
        break;
    }
    return valid;
}

void ProcessData::UserDataFile(std::string tar_directory, std::string message, ...)
{
    FileOpen(tar_directory, APPEND);

    char time_stamp[80];
    TimeStamp(time_stamp);

    va_list args;
    va_start(args, message);
    std::string output_message = vStringFormat(message.c_str(), args);
    va_end(args);

    user_file_stream << output_message << std::endl;
    user_file_stream.close();
}

void ProcessData::SessionLog(std::string message, ...)
{

    CheckFileTime( directory_vec.at(SESSION_LOG), false);

    char time_stamp[80];
    TimeStamp(time_stamp);

    va_list args;
    va_start(args, message);
    std::string output_message = vStringFormat(message.c_str(), args);
    va_end(args);

    user_file_stream << time_stamp << " " << output_message << std::endl;
    user_file_stream.close();
}

void ProcessData::ErrorLog(std::string message, ...)
{    
    CheckFileTime(directory_vec.at(ERROR_LOG), false);

    char time_stamp[80];
    TimeStamp(time_stamp);

    va_list args;
    va_start(args, message);
    std::string output_message = vStringFormat(message.c_str(), args);
    va_end(args);

    user_file_stream << time_stamp << " " << output_message << std::endl;
    user_file_stream.close();
}

void ProcessData::ChangeTargetName(std::string tar_directory, std::string find_chars, std::string new_chars)
{
    std::vector<std::string>::iterator  v_it;
    std::string f_line;

    GetFileData(tar_directory);

    // search the "file_data" vector and replace at the position of what is found ("find_chars") with "new_chars"
    for (unsigned int i = 0; i < file_data.size(); i++) {
        f_line = file_data.at(i);
        std::size_t found2 = f_line.find(find_chars);

        if (found2 != std::string::npos) {
            v_it = file_data.begin();
            file_data.erase(v_it + i);
            file_data.emplace(v_it + i, new_chars);
            break;
        }
    }
    FileReWrite(tar_directory);
}

void ProcessData::GetFileData(std::string tar_directory)
{
    FileOpen(tar_directory, READ);

    std::string line;

    while (std::getline(iuser_file_stream, line)) {
        file_data.push_back(line);
    }
    iuser_file_stream.close();
    qDebug() << "\n\t\t...file data successfully moved to internal memory.";
}

// the error appears to be fixed with flag changes
void ProcessData::FileReWrite(std::string tar_directory)
{
    FileOpen(tar_directory, TRUNCATE);

    std::string data_line;

    for (unsigned int i = 0; i < file_data.size(); i++) {
        data_line = file_data.at(i);
        user_file_stream << data_line << std::endl;
    }
    user_file_stream.close();
    file_data.clear();
    qDebug() << "\n\t\t...file re-written successfully.";
}

// output format - could probably use the string format from above for further flexibility
// what determines the format could be a another different passed variable which would add flexibility/functionality
// output_stat only determines if there are more answers to the same question
std::string ProcessData::GetOutputFormat(std::string s_index, std::string string_data, std::string output_string, int output_stat)
{
    if (output_stat == 0) { // only answer
        output_string.append(s_index + "," + string_data + "\n");
    }
    else if (output_stat == 1) { // first answer
        output_string.append(s_index + "," + string_data);
    }
    else if (output_stat == 2) { // middle anwsers
        output_string.append(", " + string_data);
    }
    else if (output_stat == 3) { // last answer
        output_string.append(", " + string_data + "\n");
    }
    return output_string;
}

// replaces data placeholders found in the vector via the XML from Word with user data
void ProcessData::ProcessUserData(std::string p_filename)
{    
    system(directory_vec.at(EXTRACT_BAT).c_str());

    GetFileData(directory_vec.at(WORD_XML_DOC));

    std::map<float, std::string>::iterator it;
    std::map<float, std::string>::iterator it2;
    std::vector<std::string>::iterator  v_it;    
    std::string string_data;
    std::string data_line;
    std::string data_string;
    std::string s_index;
    std::string s_supplant = "!!!";
    size_t str_size;
    float index;
    int counter = 0;

    //  most of these are for formatting output
    std::vector<int> num_special_fields_vec;
    std::vector<int> spec_fields;
    int special_counter = 0;
    int special_count = 0;
    int check_count = 0;
    int out_stat;
    int iter;
    bool special = false;
    int  g = 0,h = 0 ,i = 0,j = 0,k = 0;

    // check for special questions and insert their fieldID referencing the <special_field_vec>
    for (it2 = user_data_map.begin(); it2 != user_data_map.end(); ++it2) {
        index = it2->first;

        //QString q_str = QString::fromStdString(it2->second);
        //qDebug() << "user_data_map: " << q_str;
        for (h = 0; h < special_field_vec.size(); ++h) {
            if (static_cast<int>(index) == special_field_vec[h]) {
                spec_fields.push_back(static_cast<int>(index));
                num_special_fields_vec.push_back(static_cast<int>(index));
            }
        }
    }

    // searches the userdata/user_data_map vector for placeholders/index for user data inserts
    for (it = user_data_map.begin(); it != user_data_map.end(); ++it) {
        ++counter;

        index = it->first;
        string_data = it->second;        

        for (j = 0; j < spec_fields.size(); ++j) {
            if (static_cast<int>(index) == spec_fields[j]) {
                ++special_counter;
                iter = j;
                break;
            }
        }
        if (special_counter == 1) { // static_cast<int>(index) == spec_fields[j] &&
            --special_counter;
            ++special_count;
            spec_fields.erase(spec_fields.begin() + iter);

            s_index = std::to_string(index);
            str_size = s_index.size();
            s_index.resize(str_size-3);

            // if more exist, set flags for what will appear in the file
            // reference the other vector to check how many there are total to compare to count and set a switch
            for (g = 0; g < num_special_fields_vec.size(); ++g) {
                if (static_cast<int>(index) == num_special_fields_vec[g]) {
                    ++check_count;
                }
            }

            // set output_stat - which string is appended and if counts are cleared for the next fieldID
            if (special_count == 1 && check_count == special_count) {
                out_stat = 0;
            }
            else if (special_count == 1) {
                out_stat = 1;
            }
            else if (check_count == special_count) {
                out_stat = 3;
            }
            else {
                out_stat = 2;
            }

            // reset special field counts
            if (out_stat == 0 || out_stat == 3) {
                special_count = 0;
            }
            check_count = 0;

            // this counter will be used for other special formatting items - for now it's so the "first and last names" don't check against a certain format
            if (counter > 2) {
                s_index.resize(str_size-6);
                s_index = s_index + s_supplant;

                data_string = GetOutputFormat(s_index, string_data, data_string, out_stat);
                if (out_stat ==  1 || out_stat == 2) {
                    continue;
                }
            }
            else {
                data_string = GetOutputFormat(s_index, string_data, data_string, out_stat);
                if (out_stat ==  1 || out_stat == 2) {
                    continue;
                }
            }
            special = true;
        }

        if (special == false) {
            s_index = std::to_string(index);
            str_size = s_index.size();
            s_index.resize(str_size-3);

            // eventually compare the counter to an array or vector with the position values which need some special treatment
            // this array will contain the position of all the fieldID
            if (counter > 2) {
                s_index.resize(str_size-6); // resize again to insert dummy characters
                s_index = s_index + s_supplant;
            }
            data_string.append(s_index + "," + string_data + "\n");
        }
        special = false;

        // XML & FILE memory prep
        // searches the XML/file_data vector and replaces the placeholder/index with userdata/string_data from above
        for (i = 0; i < file_data.size(); i++) {
            data_line = file_data.at(i);

            std::size_t found = data_line.find(s_index);

            for (k = 0; k < num_special_fields_vec.size(); k++) {
                iter = std::stoi(s_index);

                if (iter == num_special_fields_vec[k]) { // special fields found - prepare the string formatted above
                    std::size_t found1 = data_string.find(s_index);
                    string_data = data_string.substr(found1 + s_index.length() + 1);
                    break;
                }
            }

            if (found != std::string::npos) {
                data_line.replace(data_line.find(s_index), s_index.length(), string_data);
                qDebug() << "index found at: " << found;

                file_data.erase(file_data.begin() + i);
                v_it = file_data.begin();
                file_data.insert(v_it + i, data_line);
                break;
            }
        }
    }
    // occasional isseu with the last line tag not being put in, likely due to soemthing immediately above

    //QString q_str = QString::fromStdString(data_line);
    //qDebug() << "data_line: " << q_str;
    // this is for an alternate way to process the data

    std::string tar_directory = StringFormat("%s/%s.txt", directory_vec.at(USER_DATA_FOLDER).c_str(), p_filename.c_str());
    UserDataFile(tar_directory, data_string.c_str());

    FileReWrite(directory_vec.at(WORD_XML_DOC));

    system(directory_vec.at(COMPRESS_BAT).c_str());
    system(directory_vec.at(PRINT_BAT).c_str()); // create options
    system(directory_vec.at(DEL_COMPONENTS_BAT).c_str()); // create options
    //system(directory_vec.at(DEL_FILES_BAT).c_str()); // create options
}
