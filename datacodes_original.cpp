#include <fstream>
#include <string>

#include "datacodes.h"

#include <QDebug>


std::ifstream data_code_stream;

std::map<std::string, std::vector<std::string>> file_data_map;
std::vector<std::string> response_code_vec;
std::vector<std::string> prompt_code_vec;


DataCodes::DataCodes()
{

}

void DataCodes::PrepareFileData()
{
    PrepareFieldData();

    GetFileData(data_lists_directory);

    file_data_map[DataFileString[DAYS_TXT_001]] = days_txt_001;
    file_data_map[DataFileString[MONTHS_TXT_001]] = months_txt_001;
    file_data_map[DataFileString[TEST1_TXT_001]] = test1_txt_001;
    file_data_map[DataFileString[TEST2_TXT_001]] = test2_txt_001;
}

void DataCodes::GetFileData(std::string tar_directory)
{
    std::string m_directory;
    std::string filename;
    std::string entry;
    int data_code;

    for (unsigned int i = 1; i < DataCodeID::MaxDataCode; ++i) {
        filename = DataFileString[i];
        data_code = i;

        m_directory = tar_directory + filename;
        data_code_stream.open(m_directory, std::ios_base::out | std::fstream::in);

        switch(data_code) {
        case DataCodeID::DAYS_TXT_001:
            while (std::getline(data_code_stream, entry)) {
                days_txt_001.push_back(entry);
            }
            break;
        case DataCodeID::MONTHS_TXT_001:
            while (std::getline(data_code_stream, entry)) {
                months_txt_001.push_back(entry);
            }
            break;
        case DataCodeID::TEST1_TXT_001:
            while (std::getline(data_code_stream, entry)) {
                test1_txt_001.push_back(entry);
            }
            break;
        case DataCodeID::TEST2_TXT_001:
            while (std::getline(data_code_stream, entry)) {
                test2_txt_001.push_back(entry);
            }
            break;       
        }
        data_code_stream.close();
    }
}

void DataCodes::PrepareFieldData()
{
    std::string response;
    std::string prompt;

    for (unsigned int i = 0; i < ResponseCode::MaxResponseCode; ++i) {
        response = ResponseString[i];
        response_code_vec.push_back(response);
    }
    for (unsigned int i = 0; i < PromptCode::MaxPromptCode; ++i) {
        prompt = FieldPromptString[i];
        prompt_code_vec.push_back(prompt);
    }
}
