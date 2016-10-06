#ifndef DATACODES_H
#define DATACODES_H


#include <map>
#include <vector>


#define M_FIELD_ID 11
#define M_PROMPT_ID 6
#define M_RESPONSE_ID 16


enum DataCodeID {

    No_Data_Code = 0,
    DAYS_TXT_001,
    MONTHS_TXT_001,
    TEST1_TXT_001,
    TEST2_TXT_001,
    MaxDataCode

};

static const char* DataFileString[DataCodeID::MaxDataCode] = {

    "no_vector",
    "days.txt",
    "months.txt",
    "test1.txt",
    "test2.txt",

};

enum PromptCode {

    No_Question = 0,
    MaxPromptCode = M_PROMPT_ID

};

static const char* FieldPromptString[PromptCode::MaxPromptCode] = {

    ""
    "Please enter your first and last name.",
    "Enter a random day and month.\nThen, select a random word from each list",
    "How many children do you eat daily?",
    "What's your favorite illness?",
    "Tomato or tomato?",
    "If my wife is crazy does that make me crazy?",

};

enum FieldCode {

    Empty_Field = 0,
//   FNAME,
//   LNAME,
//   DAY,
//   MONTH,
//   RANWORD1,
//   RANWORD2,
//   CHILD_CONSUMPTION,
//   ILLNESS,
//   TOMATOES,
//   IM_CRAZY,
    MaxFieldCode = M_FIELD_ID

};

enum ResponseCode {

    No_Response = 0,
    END_PROCESS,
    VARIABLE,
    DISTINCT,
//   BOGGLE,
//   AFEW,
//   ALLEVERY,
//   FLU,
//   HERPIES,
//   TYPHOID,
//   TOMATO,
//   TOMATOE,
//   INSANITY,
//   MASOCHIST,
//   DENIAL,
//   LOSER,
    MaxResponseCode = M_RESPONSE_ID

};

static const char* ResponseString[ResponseCode::MaxResponseCode] = {

    "",
    "process_data",
    "variable response",
    "distinct response",
    "???",
    "a few",
    "all on sight",
    "flu",
    "herpies",
    "typhoid",
    "tomato",
    "tomatoe",
    "I love her!",
    "PAIN!!!",
    "What?",
    "but, I love her...",

};

class DataCodes
{
public:
    DataCodes();

    void PrepareFileData();
    void GetFileData(std::string tar_directory);
    void PrepareFieldData();

    std::string data_lists_directory = "C:/MyProgram/DataFiles/Lists/";
    std::string data_prompts_directory = "C:/MyProgram/DataFiles/Prompts/";
    std::string data_responses_directory = "C:/MyProgram/DataFiles/Responses/";

    std::vector<std::string> days_txt_001;
    std::vector<std::string> months_txt_001;
    std::vector<std::string> test1_txt_001;
    std::vector<std::string> test2_txt_001;

};

extern std::map<std::string, std::vector<std::string>> file_data_map;
extern std::vector<std::string> response_code_vec;
extern std::vector<std::string> prompt_code_vec;

#endif // DATACODES_H
