#ifndef DATACODES_H
#define DATACODES_H


#include <map>
#include <vector>


#define M_FIELD_ID 11
#define M_TEXT_ID 6 // this isn't used
#define M_RESPONSE_ID 16 // this isn't used


enum DataCodeID { // these should eventually be programmed into the UI by as they change

    No_Data_Code = 0,
    DAYS_TXT,
    MONTHS_TXT,
    TEST1_TXT,
	TEST2_TXT,
    MaxDataCode

};

static const char* DataFileString[DataCodeID::MaxDataCode] = { // this should be rewritten as relative path to main folder an other files can be added easier

    "no_vector",
    "days.txt",
    "months.txt",
    "test1.txt",
	"test2.txt",

};

/*
enum PromptCode {

    No_Question = 0,
    MaxPromptCode = M_TEXT_ID // this isn't used

};


static const char* FieldPromptString[PromptCode::MaxPromptCode] = { // this isn't used

    ""
    "Please enter your first and last name.",
    "Enter a random day and month.\nThen, select a random word from each list",
    "How many children do you eat daily?",
    "What's your favorite illness?",
    "Tomato or tomato?",
    "If my wife is crazy does that make me crazy?",

};
*/

enum FieldCode {

    Empty_Field = 0,
    MaxFieldCode = M_FIELD_ID

};

enum ResponseCode {

    No_Response = 0,
    END_PROCESS,
    VARIABLE,
    DISTINCT,
    MaxResponseCode = M_RESPONSE_ID // this isn't used

};

static const char* ResponseString[ResponseCode::MaxResponseCode] = { // this isn't used

    "",
    "process_data",
    "variable response",
    "distinct response",

};

class DataCodes
{
public:
    DataCodes();

    void PrepareFileData();
    void LoadFileData(std::string tar_directory);
    void LoadFieldData();

    std::string data_lists_directory = "C:/MyProgram/DataFiles/Lists/";
    std::string data_prompts_directory = "C:/MyProgram/DataFiles/Prompts/";
    std::string data_responses_directory = "C:/MyProgram/DataFiles/Responses/";

    std::vector<std::string> days_txt;
    std::vector<std::string> months_txt;
    std::vector<std::string> test1_txt;
	std::vector<std::string> test2_txt;

};

extern std::map<std::string, std::vector<std::string>> file_data_map;
extern std::vector<std::string> text_response_vec; // this is all kinds of problems, should add a 0 in the first element or start everything at 0
extern std::vector<std::string> text_prompt_vec;

#endif // DATACODES_H
