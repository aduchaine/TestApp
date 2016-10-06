#include <fstream>
#include <string>

#include "datacodes.h"

#include <QDebug>


std::ifstream data_code_stream;

std::map<std::string, std::vector<std::string>> file_data_map;
std::vector<std::string> text_response_vec;
std::vector<std::string> text_prompt_vec;

static const int qml_component_noID[44] = { 100, 101, 102, 103, 115, 119, 120, 121, 122, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 150, 153, 154,
160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175, 176, 180, 181, 182, 183, 184 };

static const int qml_component_hasID[10] = { 110, 111, 112, 113, 114, 116, 117, 118, 151, 152 };

static const int qml_component_hasfile[18] = { 110, 111, 112, 113, 114, 115, 116, 117, 118, 122, 167, 169, 170, 171, 172, 173, 175, 176 };


DataCodes::DataCodes()
{

}

void DataCodes::PrepareFileData()
{
    LoadFileData(data_lists_directory);

	file_data_map[DataFileString[DAYS_TXT]] = days_txt;
    file_data_map[DataFileString[MONTHS_TXT]] = months_txt;
    file_data_map[DataFileString[TEST1_TXT]] = test1_txt;
	file_data_map[DataFileString[TEST2_TXT]] = test2_txt;

}

void DataCodes::LoadFieldData()
{
    std::string m_directory;
    std::string entry;

    m_directory = data_prompts_directory + "prompts.txt";
    data_code_stream.open(m_directory, std::ios_base::out | std::fstream::in);
    while (std::getline(data_code_stream, entry)) {
        text_prompt_vec.push_back(entry);
    }
    data_code_stream.close();

    m_directory = data_responses_directory + "responses.txt";
    data_code_stream.open(m_directory, std::ios_base::out | std::fstream::in);
    while (std::getline(data_code_stream, entry)) {
        text_response_vec.push_back(entry);
    }
    data_code_stream.close();
}

void DataCodes::LoadFileData(std::string tar_directory)
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
		case DataCodeID::DAYS_TXT:
			while (std::getline(data_code_stream, entry)) {
				days_txt.push_back(entry);
			}
			break;
		case DataCodeID::MONTHS_TXT:
			while (std::getline(data_code_stream, entry)) {
				months_txt.push_back(entry);
            }
			break;
		case DataCodeID::TEST1_TXT:
			while (std::getline(data_code_stream, entry)) {
				test1_txt.push_back(entry);
			}
            break;
        case DataCodeID::TEST2_TXT:
            while (std::getline(data_code_stream, entry)) {
                test2_txt.push_back(entry);
            }
            break;
        }
        data_code_stream.close();
    }
}
