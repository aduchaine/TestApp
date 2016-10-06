#ifndef DATACODES_TEST_H
#define DATACODES_TEST_H

// these two files are for notes/test work

#include <map>
#include <vector>


#define M_FIELD_ID 11
#define M_TEXT_ID 6
#define M_RESPONSE_ID 16


// these correspond to data sets/lists - the files aren't the context
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


// this symbolizes either file data or, eventually, admin input

// distinct fields - we need to have an accurate count - this is the reason for the individual names - count could be varified in the UI code
// FieldCode corresponds to specific fields
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

// distinct prompts of text - text strings are below - uncertain if text labels should be included, probably not since the data is listed and can be counted
// these are the questions
enum PromptCode {

    No_Question = 0,
    MaxPromptCode = M_TEXT_ID

};

// this is the text which will elicit responses - many of the responses are accessed through lists or a more limited response which are listed here
static const char* FieldPromptString[PromptCode::MaxPromptCode] = {

    ""
    "Please enter your first and last name.",
    "Enter a random day and month.\nThen, select a random word from each list",
    "How many children do you eat daily?",
    "What's your favorite illness?",
    "Tomato or tomato?",
    "If my wife is crazy does that make me crazy?",

};

// ResponseCode lists specific responses; 1-3 are flags for other processes and must remain in their positions
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

// list of mundane responses - the MaxResponseCode must correspond with the # of strings below
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

class DataCodesTest
{
public:
    DataCodesTest();

    void PrepareFileData();
    void GetFileData(std::string tar_directory);
    void PrepareFieldData();

    std::string data_lists_directory = "C:/MyProgram/DataFiles/";

    std::vector<std::string> days_txt_001;
    std::vector<std::string> months_txt_001;
    std::vector<std::string> test1_txt_001;
    std::vector<std::string> test2_txt_001;

};

extern std::map<std::string, std::vector<std::string>> tfile_data_map;
extern std::vector<std::string> tresponse_code_vec;
extern std::vector<std::string> tprompt_code_vec;

#endif // DATACODES_TEST_H
