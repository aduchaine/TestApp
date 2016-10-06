#ifndef PROCESSDATA_H
#define PROCESSDATA_H

#include <QObject>
#include <string>

// think about using the enumerated values below instead of some of these - it's an extra step to remember to change these - removed form all implemetation
//#define L_PAGE_NUM 8            // always 1 more than actual last page
//#define M_CONFIRM_TYPE 6        // always 1 more than actual max types of data confirmation
//#define MAX_POSS_RESPONSE 69    // always 1 more than actual - this is based on the data_code vector with the largest size() or spcific number response
//#define M_DATA_CODE 4           // types of data sets, always 1 more than actual


// all of these are used during processing of data - datacodes directories are separate
// the directories in "createdirectoy()" are all directories the program will use
// this should be renamed to avoid confusion
enum FileDirectories {

    No_Listing = 0,
    WORD_XML_DOC,
    EXTRACT_BAT,
    COMPRESS_BAT,
    PRINT_BAT,
    DEL_COMPONENTS_BAT,
    DEL_FILES_BAT,
    ERROR_LOG,
    SESSION_LOG,    
    USER_DATA_FOLDER,
    WORD_DOC_FOLDER,
    MaxDirectoryID

};

static const char* DirectoryString[FileDirectories::MaxDirectoryID] = {

    "",
    "C:/MyProgram/TestApp/Form/form_template/word/document.xml",
    "C:/MyProgram/TestApp/Batch_files/extract.bat",
    "C:/MyProgram/TestApp/batch_files/compress.bat",
    "C:/MyProgram/TestApp/batch_files/print.bat",
    "C:/MyProgram/TestApp/batch_files/delete_components.bat",
    "C:/MyProgram/TestApp/batch_files/delete_files.bat",
    "C:/MyProgram/Logs/Error/error_log",
    "C:/MyProgram/Logs/User/session_log",    
    "C:/MyProgram/Documents/User_data",
    "C:/MyProgram/Documents",

};

// may not be needed with "DataCodes" - the only usage is to get mundane "ResponseString" above
// not true, it won't know to toggle other buttons otherwise - although it could use the array instead - redo this eventually
// question and response are mapped and used in the files for id
// --- // -- this is for organizational purposes mostly - so people can understand what a flag means
namespace Question {

    // sets flag for number and type of acceptable responses per fieldID
    enum ConfirmType {

        No_Confirmation = 0,
        PROCESS_DATA,
        STRING_VALIDATE,
        SINGLE_REQ,
        SINGLE_ACC,
        MULTIPLE_REQ,
        MaxConfirmType // = M_CONFIRM_TYPE

    };

}

enum FileOpenStatus {

    NONE = 0,
    READ = 1,
    CREATE = 2,
    APPEND = 3,
    TRUNCATE = 4

};

class ProcessData
{
public:
    ProcessData();

    void TimeStamp(char * time_stamp);

    const std::string vStringFormat(const char * format, va_list args);
    const std::string StringFormat(const char * format, ...);

    // startup file/data/memory
    void PrepareUIData();
    void GetDirectories();

    // file manipulation
    void MakeDirectory(const std::string &directory_name);
    void CreateDirectories();
    bool FileOpen(std::string tar_directory, int open_status); // main file open function

    // file nomenclature and routing
    std::string CheckOutputFile(std::string p_filename);
    bool CheckFileTime(std::string tar_directory, bool startup);
    void FileTime(char * time_stamp);
    void CheckFiles();

    void UserDataFile(std::string tar_directory, std::string message, ...);
    void SessionLog(std::string message, ...);
    void ErrorLog(std::string message, ...);

        // data processing
    void GetFileData(std::string tar_directory);
    void FileReWrite(std::string tar_directory);
    std::string GetOutputFormat(std::string s_index, std::string string_data, std::string output_string, int output_stat);

    void ProcessUserData(std::string p_filename);
    void ChangeTargetName(std::string tar_directory, std::string find_chars, std::string new_chars); // used to change specific file contents

};

extern std::vector<std::string> directory_vec;

#endif // PROCESSDATA_H
