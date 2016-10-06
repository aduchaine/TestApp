#include <QDebug>
#include <vector>
#include <map>
#include <fstream> // std::ofstream

#include "uiprocess.h"
#include "processdata.h"
#include "datacodes.h"


// keyboard prop location is insignificant and can be left in...
// other similar items where location isn't important used in many/most/all pages should also be grouped together
// 999 is end of qml(no component), 0 is delimted compnents to the right, -1 are invalid/empty

static const int componentID_from_pageID[33][8] = {
//                    Page:
//     0,   1,   2,   3,   4,   5,   6,   7

	{ 100, 100, 100, 100, 100, 100, 100, 100 },    // 1st ComonentID of page
	{ 101, 101, 101, 101, 101, 101, 101, 101 },    // 2nd ComonentID of page
	{ 102, 102, 102, 102, 102, 102, 102, 102 },    // 3rd ComonentID of page
	{ 110, 110, 110, 110, 110, 110, 110, 110 },    // 4th ComonentID of page
	{ 111, 111, 111, 111, 111, 111, 111, 111 },    // 5th ComonentID of page
	{ 110, 110, 110, 110, 110, 110, 110, 110 },    // 6th ComonentID of page
	{ 111, 151, 151, 151, 152, 151, 152, 111 },    // 7th ComonentID of page
	{ 110, 112, 113, 116, 116, 116, 116, 110 },    // 8th ComonentID of page
	{ 111, 112, 113, 116, 116, 116, 116, 111 },    // 9th ComonentID of page
	{ 110, 150, 114, 116, 116, 150, 116, 110 },    // 10th ComonentID of page
	{ 151, 110, 114, 150, 150, 110, 116, 151 },    // 11th ComonentID of page
	{ 150, 151, 150, 110, 110, 151, 150, 117 },    // 12th ComonentID of page
	{ 110, 117, 110, 151, 151, 117, 110, 118 },    // 13th ComonentID of page
	{ 118, 118, 151, 117, 117, 118, 151, 150 },    // 14th ComonentID of page
	{ 119, 150, 117, 118, 118, 150, 117, 119 },    // 15th ComonentID of page
	{ 130, 120, 118, 150, 150, 119, 118, 130 },    // 16th ComonentID of page
	{ 121, 138, 150, 119, 119, 130, 150, 131 },    // 17th ComonentID of page
	{ 115, 121, 120, 130, 130, 132, 119, 133 },    // 18th ComonentID of page
	{ 103, 119, 138, 132, 132, 133, 130, 121 },    // 19th ComonentID of page
	{ 999, 139, 121, 133, 133, 121, 132, 115 },    // 20th ComonentID of page
	{  -1, 134, 119, 121, 121, 115, 133, 103 },
	{  -1, 130, 139, 115, 115, 103, 121, 999 },
	{  -1, 131, 137, 103, 103, 999, 115,  -1 },
	{  -1, 133, 136, 999, 999,  -1, 103,  -1 },
	{  -1, 121, 135,  -1,  -1,  -1, 999,  -1 },
	{  -1, 122, 130,  -1,  -1,  -1,  -1,  -1 },
	{  -1, 115, 132,  -1,  -1,  -1,  -1,  -1 },
	{  -1, 103, 133,  -1,  -1,  -1,  -1,  -1 },
	{  -1, 999, 121,  -1,  -1,  -1,  -1,  -1 },
	{  -1,  -1, 122,  -1,  -1,  -1,  -1,  -1 },
	{  -1,  -1, 115,  -1,  -1,  -1,  -1,  -1 },
	{  -1,  -1, 103,  -1,  -1,  -1,  -1,  -1 },
	{  -1,  -1, 999,  -1,  -1,  -1,  -1,  -1 },

};


// many of these could be created as the components within the page are created above if the component has a standard use
// responseID and fieldID would be more difficult but possible if the app data is present
static const int fieldID_to_pageID[]         = { 0, 1, 1, 2, 2, 2, 2, 3, 4, 5, 6, 7 };   // fieldID 1-10 + final processing
static const int fieldID_to_num_responses[]  = { 0, 1, 1, 1, 1, 1, 1, 3, 3, 2, 4, 1 };   // fieldID 0-11
static const int fieldID_to_datacodeID[]     = { 0, 0, 0, 1, 2, 3, 4, 0, 0, 0, 0, 0 };   // fieldID 1-10 + final processing
static const int fieldID_to_confirmID[]      = { 0, 2, 2, 5, 5, 5, 5, 3, 3, 3, 4, 1 };   // fieldID 1-10 + final processing
static const int pageID_to_num_inputfields[] = { 0, 2, 4, 1, 1, 1, 1, 1 };               // pageID 0-7
static const int pageID_to_num_textfields[]  = { 3, 1, 1, 1, 1, 1, 1, 3 };               // pageID 0-7
static const int confirmID_to_switch[]       = { 0, 0, 0, 1, 0, 1 };                     // confirmID 1-5 - 1 allows multiple responses per page - this isn't all that useful with everything else added since
static const int datacodeID_to_fieldID[]     = { 0, 3, 4, 5, 6 };                        // dataCodeID 1-4

static const int fieldID_from_pageID[4][8] = {
//  			Page:
//     0, 1, 2, 3, 4, 5,  6,  7

      {0, 1, 3, 7, 8, 9, 10, 11},    // 1st FieldID of page
      {0, 2, 4, 0, 0, 0,  0,  0},    // 2nd FieldID of page
      {0, 0, 5, 0, 0, 0,  0,  0},    // 3rd FieldID of page
      {0, 0, 6, 0, 0, 0,  0,  0},    // 4th FieldID of page
};

static const int textID_from_pageID[4][8] = {
//  			Page:
//     0, 1, 2, 3, 4, 5, 6,  7

      {1, 4, 5, 6, 7, 8, 9, 10 },    // 1st TextID of page
      {2, 0, 0, 0, 0, 0, 0, 11 },    // 2nd TextID of page
      {3, 0, 0, 0, 0, 0, 0, 12 },    // 3rd TextID of page
      {0, 0, 0, 0, 0, 0, 0,  0 },    // 4th TextID of page
};

static const int responseID_from_fieldID[4][12] = {
//                  FieldID:
//     0, 1, 2, 3, 4, 5, 6, 7, 8,  9, 10, 11

      {0, 2, 2, 3, 3, 3, 3, 4, 7, 10, 12,  1},   // 1st responseID of field
      {0, 0, 0, 0, 0, 0, 0, 5, 8, 11, 13,  0},   // 2nd responseID of field
      {0, 0, 0, 0, 0, 0, 0, 6, 9,  0, 14,  0},   // 3rd responseID of field
      {0, 0, 0, 0, 0, 0, 0, 0, 0,  0, 15,  0},   // 4th responseID of field
};

// Vkeyboard usage
bool caps_lock = false;

std::vector<int> fieldID_vec;
std::vector<int> textfieldID_vec;
std::vector<int> responseID_vec;

std::map<float, std::string> response_map;
std::map<int, std::string> string_map;
std::map<float, std::string> user_data_map;

std::string username;
std::string f_name;
std::string l_name;

// this gets found in the batch files
std::string fCBATstring = "7z";
std::string fPBATstring = "WINWORD.EXE";
std::string fDBATstring = "del /F /Q /A";


// ----------------------  NEW_ADD_TO_TESTCLIENT_UI



UIProcess::UIProcess(QObject *parent) : QObject(parent)
{

}

QString UIProcess::ps_data1() const
{
    return s_data1;
}

void UIProcess::setS_data1(const QString &ps_data1)
{
    s_data1 = ps_data1;
}

int UIProcess::pi_data1() const
{
    return i_data1;
}

void UIProcess::setI_data1(const int &pi_data1)
{
    i_data1 = pi_data1;
}

int UIProcess::pi_data2() const
{
    return i_data2;
}

void UIProcess::setI_data2(const int &pi_data2)
{
    i_data2 = pi_data2;
}

int UIProcess::pi_data3() const
{
    return i_data3;
}

void UIProcess::setI_data3(const int &pi_data3)
{
    i_data3 = pi_data3;
}

bool UIProcess::pb_data1() const
{
    return b_data1;
}

void UIProcess::setB_data1(const bool &pb_data1)
{
    b_data1 = pb_data1;
}

// --------------------  NEW_ADD_TO_TESTCLIENT_UI


// --------------------  NEW_ADD_TO_TESTCLIENT_UI above


void UIProcess::sendPromptData(int page_id)
{
   // qDebug() << "sendPromptData: text_id-prompt_data " << text_id << "-" << q_prompt_data;
    std::string text_data;
    QString q_text_data;
    int text_id;
    size_t found;

    GetTextID(page_id);

    for (unsigned i = 0; i < textfieldID_vec.size(); i++) {
        text_id = textfieldID_vec.at(i);
        text_data = text_prompt_vec.at(text_id - 1);

        found = text_data.find("\\n");
        if (found != std::string::npos) {
            text_data.replace(found, 2, "\n");
        }

        q_text_data = QString::fromStdString(text_data);
        //qDebug() << "sendPromptData: text_id-q_text_data " << text_id << "-" << q_text_data;

        emit sendToPrompt(text_id, q_text_data);
    }
    textfieldID_vec.clear();

//    prompt_data = text_prompt_vec.at(text_id);
//    // need a character handling function probably similar to the chat char input function in Novice for loading file data and special characters
//    found = prompt_data.find("\\n");
//    if (found != std::string::npos) {
//        prompt_data.replace(found, 2, "\n");
//    }
//    q_prompt_data = QString::fromStdString(prompt_data);
//    //qDebug() << "sendPromptData: text_id-prompt_data " << text_id << "-" << q_prompt_data;
//
//    emit sendToPrompt(text_id, q_prompt_data);

}

// to add text to buttons - will need to account for in the UI, switches with larger sets of responses
// which don't use a menu/list and only use one area to accept input
void UIProcess::sendFieldData(int page_id)
{
    std::string field_data;
    QString q_field_data;
    int field_id;
    int response_id;
    //size_t return_count = 0; // this isn't needed until complete customization - this could be used when startup after customizing to recognize number of fields in UI to create

    GetFieldID(page_id);

    for (unsigned i = 0; i < fieldID_vec.size(); i++) {
        field_id = fieldID_vec.at(i);
        GetResponseIDs(field_id);

        for (unsigned int i = 0; i < responseID_vec.size(); ++i) {
            if (responseID_vec.at(i) <= DISTINCT) {
                continue;
            }

            response_id = responseID_vec[i];
            field_data = text_response_vec.at(response_id - 1); // text_id - 1 - this is for text document pop -  revert the -1 otherwise
            q_field_data = QString::fromStdString(field_data);

            //qDebug() << "sendFieldData: response_id-field_data " << response_id << "-" << q_field_data;

            emit sendToField(field_id, response_id, q_field_data);
        }
        responseID_vec.clear();
    }
    fieldID_vec.clear();

 //   std::string field_data;
 //   QString q_field_data;
 //   int response_id;
 //   //size_t return_count = 0; // this isn't needed until complete customization - this could be used when startup after customizing to recognize number of fields in UI to create
 //
 //   GetResponseIDs(field_id);
 //
 //   for (unsigned int i = 0; i < responseID_vec.size(); ++i) {
 //       response_id = responseID_vec[i];
 //       field_data = text_response_vec.at(response_id - 1); // text_id - 1 - this is for text document pop -  revert the -1 otherwise
 //       q_field_data = QString::fromStdString(field_data);
 //
 //       //qDebug() << "sendFieldData: response_id-field_data " << response_id << "-" << q_field_data;
 //
 //       emit sendToField(field_id, response_id, q_field_data);
 //   }
 //   responseID_vec.clear();

}

// eventually use field_id to send data
void UIProcess::sendMenuData(int page_id)
{
    std::vector<std::string> all_words_vec;
    std::string menu_data;
    QString q_menu_data;
    size_t return_count = 0;


    int data_code;

    GetFieldID(page_id);

    if (fieldID_vec.size() == 0) {
        return;
    }
    for (unsigned i = 0; i < fieldID_vec.size(); i++) {
        data_code = GetDataCodeFromFieldID(fieldID_vec.at(i));

        //field = GetFieldIDFromDataCode(data_code);

        all_words_vec = file_data_map[DataFileString[data_code]];
        return_count = all_words_vec.size();

        //qDebug() << "sendMenuData: 1 data_code " << data_code;
        //qDebug() << "sendMenuData: 2 qID" << field;
        //qDebug() << "sendMenuData: 3 return_count " << return_count;

        emit sendWordCount(data_code, static_cast<int>(return_count)); // issue with size_t vs int - fix this eventually

        for (unsigned int i = 0; i < all_words_vec.size(); ++i) {
            menu_data = all_words_vec[i];
            q_menu_data = QString::fromStdString(menu_data);
            //qDebug() << "sendMenuData: 4 pos-menu_data " << i << "-" << q_menu_data;
            emit sendWords(data_code, q_menu_data);
        }
    }
    fieldID_vec.clear();
}

// ---- AutoComplete function ---- //
void UIProcess::checkAutoComplete()
{
    std::vector<std::string> all_words_vec;
    std::vector<std::string> ac_words;
    std::string response;
    std::string trunc_res;
    QString q_response;
    size_t input_len = 0;
    size_t response_len = 0;
    int return_count = 0;

        // -------   autofill description   ---------
    // get fieldID to ID in the UI easier
    // get strlen of input data (s_data1)
    // link the map-vector to the i_data3
    // iterate through the strings and get string lengths
    // remove the shorter checked data strings by passing to next iteration
    // truncate all qualified data strings
    // do signal - > return the 1st match in the window/return first 10? in a menu
    // send how many words and fieldID - if 0 words, don't open menu list or close it
    // send the words prefixed by a header of the field and how many are incoming
    // send words

    //field = GetFieldIDFromDataCode(i_data3);

    if (i_data3 <= 0) {
        return;
    }

    input_len = s_data1.length();
    all_words_vec = file_data_map[DataFileString[i_data3]];

    for (unsigned int i = 0; i < all_words_vec.size(); i++) {
        if (return_count >= 10) {
            break;
        }

        response = all_words_vec[i];
        response_len = response.length();

        if (response_len <= input_len) {
            continue;
        }

        q_response = QString::fromStdString(response);
        QString qtrunc_res = q_response;

        trunc_res = response.substr (0, input_len);
        qtrunc_res = QString::fromStdString(trunc_res);

        if (qtrunc_res == s_data1) {
            ++return_count;
            ac_words.push_back(response);
            q_response = QString::fromStdString(response);
            //qDebug() << "all_words_vec: count-response -> " << return_count << "-" << q_response << "-" << qtrunc_res;
        }
    }
    emit sendWordCount(i_data3, return_count);

    if (return_count > 0) {
        for (unsigned int j = 0; j < ac_words.size(); ++j) {
            response = ac_words[j];
            q_response = QString::fromStdString(response);
            emit sendWords(i_data3, q_response);
        }
    }

    all_words_vec.clear();
    ac_words.clear();
    return_count = 0;
    i_data3 = 0;
    s_data1.clear();
}

// ---- virtual keyboard functions - <i_data2> is equivalent to the field on foucs
/* - this shouldn't be needed

//bool VKenabled = false;

void UIProcess::setVKenabled(int vk_enabled)
{
    VKenabled = pi_data1;
    emit setVKenable(vk_enabled);
    // emit response to set variable in ui
}
*/

void UIProcess::processVKey(QString key_value)
{
    // should not be able to use the Vkeyboard where there are no text fields although this should be handled UI side
    if (i_data2 < 0) {
        emit invalidData();
        return;
    }
    if (key_value == "SHIFT") {
        caps_lock == false ? setCaps(true) : setCaps(false);
        //caps_lock == false ? caps_lock = true : caps_lock = false;
    }
    if (caps_lock == true && key_value.length() == 1) {
        key_value = key_value.toUpper();
    }

    //qDebug() << "processVKey: caps_lock.key = " << caps_lock << "-" << key_value;
    //qDebug() << "processVKey: i_data2-key_value  " << i_data2 << "-" << key_value;
    emit sendKeyToField(i_data2, key_value);
}

void UIProcess::setCaps(bool caps)
{
    if (caps == true) {
        caps_lock = true;
    }
    else {
        caps_lock = false;
    }
    //qDebug() << "UIProcess caps = " <<  caps_lock;
}

// this function will evolve as my understanding of how it works does
// there will likely be an enumerated list of what to set the focus to upon signal recv in the UI
void UIProcess::setFocus(int focus_type)
{
    if (focus_type == 1) {
        emit sendFocusType(1);
    }
}


void UIProcess::processQuit()
{
    ProcessData Pdata;
    Pdata.SessionLog("[%s] ended the session by \"Quit\".", username.length() >= 4 ? username.c_str() : "BLANK");
}

// sets page-process count based on current <username_map> contents and size - done when leaving/clicking another field(does not work properly atm)
void UIProcess::checkString()
{
    if (i_data2 < 0) {
        i_data2 = 0;
        //qDebug() << "checkString i_data2-m_data  " << i_data2 << "-" << s_data1;
        emit invalidData();
        return;
    }
    // only legitimate strings should pass through - strings in data sets should be converted to to thier int position before getting here
    // this may still leave previously valid answers in the response_map
    if (i_data1 > ResponseCode::VARIABLE) {
        RemoveResponse(i_data2);
        //qDebug() << "checkString  RemoveResponse i_data2-s_data1-i_response " << i_data2 << "-" << s_data1 << "-" << i_response;
        emit noData();
        return;
    }

    std::string string_data;
    string_data = s_data1.toUtf8().constData(); // this also works -> <namestring = m_data.toLocal8Bit().constData();>

    //qDebug() << "checkString i_data2-m_data  " << i_data2 << "-" << s_data1;
    string_map[i_data2] = string_data;

    i_data1 = 0;
    i_data2 = 0;
    s_data1.clear();
}

bool UIProcess::RemoveResponse(int field_id)
{
    std::map<float, std::string>::iterator it;
    int data_code = 0;
    int response;
    bool reset = true;


    //qDebug() << "RemoveResponse1  ";
    for (it = response_map.begin(); it != response_map.end(); ++it) {
        //qDebug() << "RemoveResponse2  ";
        if (field_id == static_cast<int>(it->first)) {
            response = (it->first - field_id) * 1001;
            if (i_data1 == response) {
                data_code = GetDataCodeFromFieldID(field_id);
                if (data_code == 0) {
                    reset = false;
                }
            }
            //qDebug() << "RemoveResponse: replace-erase -> resp_compare " << response << "-" << i_data1;
            response_map.erase (it); // this can probably go up a couple lines
            if (data_code == 0) {
                emit changeState(response, false);
            }
            break;
        }
    }
    return reset;
}

// handles button click data storage
// forget the passed variables and do it like below
void UIProcess::processClick()
{
    if (i_data1 < 1) { // || i_data1 >= MAX_POSS_RESPONSE - this isn't necessary, esp with customizing data
        i_data1 = 0;
    }
    if (i_data2 < 1) { // || i_data2 >= PromptCode::MaxPromptCode - this isn't necessary
        i_data2 = 0;
    }
    std::map<float, std::string>::iterator it;
    std::string s_response;
    float pr_stat;
    int confirm_status = 0;
    bool replace = false;
    bool reset = false;

    confirm_status = GetConfirmID(i_data2);
    replace = ReplacePrevData(confirm_status);

    //qDebug() << "processClick replace-confirm_status  " << replace << "-" << confirm_status << "-" << i_data2;
    if (replace == true) { // for most button pages except 4button, currently
        reset = RemoveResponse(i_data2);
    }
    else { // for multiple answers to one field
        //qDebug() << "processClick insert " << i_response;
        pr_stat = i_data2 + static_cast<float>(i_data1) / 1000;
        it = response_map.find(pr_stat);

        if (it != response_map.end()) {
            response_map.erase (it);
            //qDebug() << "processClick insert-erase same " << i_response;
        }
        else {
            s_response = GetStringResponse(i_data2, i_data1);
            response_map[pr_stat] = s_response;
            //qDebug() << "processClick insert-add new " << i_response;
        }
    }
    if (reset == true) {
        s_response = GetStringResponse(i_data2, i_data1);
        pr_stat = i_data2 + static_cast<float>(i_data1) / 1000;
        response_map[pr_stat] = s_response;
        //QString q_response = QString::fromStdString(s_response);
       // qDebug() << "processClick: reset -> responce-i_response-pr_stat " << q_response << "-" << i_data1 << "-" << pr_stat;
    }
    i_data1 = 0;
    i_data2 = 0;
}

/*
- confirm_status == 1:
    - iterate and analyze map data to make sure each field has an entry - probably not necessary
        - goto page with bad data - assure "next" will work and possibly make another button to skip linear navigation
        - probably not necessary but is great for learning and review options
    - an array or some other type of structure(list) combined with a string-response map loaded on startup is likely all that's needed to check against and process
*/
// this could be considered a main processing loop
void UIProcess::confirmData(int page)
{
    /*
     confirm_status = 1 -> final data processing
     confirm_status = 2 -> string data, single page(currently)
     confirm_status = 3 -> mouse/button clicks, single page, one answer required
     confirm_status = 4 -> mouse/button clicks, single page, one answer required, more than one answer acceptable
     confirm_status = 11+ -> mouse/button clicks, single page, multiple answers required, multiple fields

    */
    ProcessData Pdata;
    int min_page_processes = 0;
    int confirm_status = 0;
    int page_processes = 0;
    int field = 0;
    int q_counter = 0;

    //qDebug() << "confirmData: BEGIN DO page_processes & GetFieldID ";

    min_page_processes = GetMinPageProcesses(page);
    page_processes = GetPageProcesses(page);
    GetFieldID(page);

    for (unsigned i = 0; i < fieldID_vec.size(); i++) {
        field = fieldID_vec.at(i);
        confirm_status = GetConfirmID(field);

        if (confirm_status == Question::STRING_VALIDATE) { // currently for name strings
            ++q_counter;
            //qDebug() << "confirmData: ValidateString->field_id-count " << field_id << "-" << q_counter;
            if (ValidateString(field) == false) {
                emit invalidData();
                break;
            }
            // for username only
            if (q_counter == 2) { // was "else if"
                emit validData(page + 1);
                if (username != l_name + ", " + f_name) {
                    if (username.length() >= 4) {
                        username = l_name + ", " + f_name;
                        Pdata.SessionLog("[%s] edited name.", username.c_str());
                    }
                    else {
                        username = l_name + ", " + f_name;
                        Pdata.SessionLog("[%s] has begun the session.", username.c_str());
                    }
                }
            }
        }
        // a new function similar to processClick() will likely need to be made to handle the extra variable in the chosen answer
        // the variables are page number, required responses per page, field id, response id and now data codes (fow larger possible definitive responses)
        // adding this section changes this part of program and I'll need to organize how it works differently based on this - mostly done
        // each page will require a different number of required responses (page_processes) - this funcrion need to be done yet, some of it's done
        // pages with multiple fields will need to check all fields before emitting a signal
        // same as -> (confirm_status == Question::SINGLE_REQ || confirm_status == Question::SINGLE_ACC || confirm_status == Question::MULTIPLE_REQ)
        else if (confirm_status > 2) {
            //++q_counter;
            //qDebug() << "confirmData: page_processes(page:act:req) (" << page << ":" << page_processes << ":" << min_page_processes << ")";
            if (page_processes < min_page_processes) {
                emit noData();
                break;
            }
            else {
                emit validData(page + 1);
            }
        }
    }

    if (confirm_status == Question::PROCESS_DATA) { // final process
        //qDebug() << "confirmData: PROCESS_DATA " << page_processes << "-" << min_page_processes;
        if (page_processes == min_page_processes) {
            ProcessStringMap();
            emit processedData();
        }
        else {
            emit noData();
        }
    }
    // "BeginPage" confirmation
    else if (page == 0) {
        //qDebug() << "confirmData: BeginPage -> at least it better be ";
        emit validData(page + 1);
    }
    fieldID_vec.clear();
    //qDebug() << "confirmData: END ";
}

// use this to setup nextpage button states - this will not process if no data exists(ie. page_processes = 0)
void UIProcess::getNextData(int page)
{
    std::map<float, std::string>::iterator it;
    std::map<int, std::string>::iterator it2;
    QString qp_string;
    std::string p_string;
    int confirm_status = 0;
    int page_processes = 0;
    int data_code = 0;
    int field = 0;
    int response = 0;

    page_processes = GetPageProcesses(page);

    GetFieldID(page);

    for (unsigned i = 0; i < fieldID_vec.size(); i++) {
        field = fieldID_vec.at(i);
        confirm_status = GetConfirmID(field);

        if (confirm_status > Question::STRING_VALIDATE) {
            if (page_processes > 0) { //  && page < L_PAGE_NUM - was there so it didn't process items beyond max page but it's not needed
                for (it = response_map.begin(); it != response_map.end(); ++it) {
                    if (field == static_cast<int>(it->first)) {
                        response = (it->first - field) * 1001;
                        p_string = it->second;
                        data_code = GetDataCodeID(field);
                        //qDebug() << "response_map: it->first-field-response " << it->first << "-" << field << "-" << response;
                        // this does the "file_data_map" processing if the field checks to use this map
                        if (data_code != 0) {
                            for (unsigned int j = 0; j < file_data_map[DataFileString[MaxDataCode - 1]].size(); j++) { // (j = 1) M_DATA_CODE are # of vector data_sets
                                if (p_string == (file_data_map[DataFileString[data_code]]).at(j)) {
                                    //QString q_string = QString::fromStdString(p_string);
                                    //qDebug() << "getNextData: found from data_code  " << q_string;
                                    emit dataCode(response, data_code);
                                    break;
                                }
                            }
                        }
                        emit changeState(response, true);
                    }
                }
            }
        }
        else if (confirm_status == Question::STRING_VALIDATE) {
            for (it2 = string_map.begin(); it2 != string_map.end(); ++it2) {
                if (field == it2->first) {
                    p_string = it2->second;
                    qp_string = QString::fromStdString(p_string);
                    //qDebug() << "getNextData: STRING_VALIDATE str-qID " << qp_string << "-" << "-" << field;
                    //qDebug() << "getNextData: string_map.size() " << string_map.size();
                    emit stringData(qp_string, field);
                    break;
                }
            }
        }
    }
    fieldID_vec.clear();
}

void UIProcess::getPreviousPage(int current_page)
{
    int previous_page = 0;

    //qDebug() << "getPreviousPage: current_page " << current_page;
    if (current_page == 0) {
        return;
    }
    if (current_page > 0) {
        previous_page = current_page - 1;
    }
    //qDebug() << "getPreviousPage: previous_page " << previous_page;

    emit previousPage(previous_page);
}

// the result of this will determine if the user goes to the next page
// change the map name and possibly implementation for braoder use
int UIProcess::GetPageProcesses(int page)
{
    std::map<float, std::string>::iterator it;
    int page_processes = 0;
    int confirm_status = 0;
    int field_id = 0;

    GetFieldID(page);

    for (unsigned i = 0; i < fieldID_vec.size(); i++) {
        field_id = fieldID_vec.at(i);
        confirm_status = GetConfirmID(field_id);

        if (confirm_status == Question::SINGLE_REQ || confirm_status == Question::SINGLE_ACC){
            for (it = response_map.begin(); it != response_map.end(); ++it) {
                if (field_id == static_cast<int>(it->first)) {
                    ++page_processes;
                    //qDebug() << "GetPageProcesses: SINGLE_REQ " << page_processes;
                }
            }
        }
        else if (confirm_status == Question::MULTIPLE_REQ) {
            for (it = response_map.begin(); it != response_map.end(); ++it) {
                if (field_id == static_cast<int>(it->first)) {
                    ++page_processes;
                    //qDebug() << "GetPageProcesses: MULTIPLE_REQ " << page_processes;
                }
            }
        }
        else if (confirm_status == Question::PROCESS_DATA) {
            //qDebug() << "GetPageProcesses: PROCESS_DATA = 1 ";
            page_processes = 1;
        }
    }
    //qDebug() << "GetPageProcesses: END ";
    fieldID_vec.clear();
    return page_processes;
}

std::string UIProcess::GetStringResponse(int field_id, int num_response)
{
    std::string response;
    int confirm_id = 0;

    if (i_data3 < 0 || i_data3 >= MaxDataCode) {
        i_data3 = 0;
    }

    //qDebug() << "field_id-i_data3-num_response: " << field_id << "-" << i_data3 << "-" << num_response;
    if (field_id == GetFieldIDFromDataCode(i_data3)) {
        for (unsigned int j = 0; j < file_data_map[DataFileString[MaxDataCode - 1]].size(); j++) { // "M_DATA_CODE / MaxDataCode - 1 not as clean looking
            response = file_data_map[DataFileString[i_data3]].at(num_response);
            //QString q_string = QString::fromStdString(response);
            //qDebug() << "GetStringResponse: found " << q_string;
            break;
        }
        i_data3 = 0;
        return response;
    }
    confirm_id = GetConfirmID(field_id);
    if (confirm_id != Question::MULTIPLE_REQ) {
        response = text_response_vec[num_response - 1]; // ResponseString[num_response]; // response_code_vec need to redo this for getting data from the vector
    }
    //qDebug() << "num_response-confirm_id: " << num_response << "-" << confirm_id;
    return response;
}

// 0 = passed, 1 = badchar, 2 = badlength
int UIProcess::IsValidInput(std::string p_input, bool check_acceptable, bool check_restricted, bool check_length, const char * valid_chars, const char * invalid_chars, int min_length, int max_length)
{
    int passed_check = 0;

    std::string check_char(p_input);

    const unsigned int maxcharlength = max_length;
    const unsigned int mincharlength = min_length;

    if (check_acceptable == true) {
        if (check_char.find("  ") != std::string::npos) {
                passed_check = 1;
            }
        if (check_char.find_first_not_of(valid_chars) != std::string::npos) {
            passed_check = 1;
        }
    }
    if (check_restricted == true) {
        if (check_char.find_first_of(invalid_chars) != std::string::npos) {
            passed_check = 1;
        }
    }
    if (check_length == true) {
        if (p_input.size() > maxcharlength || p_input.size() < mincharlength) {
            passed_check = 2;
        }
    }
    //qDebug() << "IsValidInput: passed_check = " << passed_check;
    return passed_check;
}

// when better nextButton with text field ID is implemented the above function and this one should be combined/changed
bool UIProcess::ValidateString(int field_id)
{
    std::map<int, std::string>::iterator it;
    std::string p_string;
    int passed_check = -1;
    bool passed = false;

    p_string = string_map[field_id];
    passed_check = IsValidInput(p_string.c_str(), true, false, true, NAME_CHAR, NULL, 2, 25);

    if (passed_check == 0) {
        passed = true;
    }

    if (field_id == 1 || field_id == 2) {
        if (field_id == 1) {
            f_name = string_map[field_id];
        }
        else if (field_id == 2) {
            l_name = string_map[field_id];
        }
        if (string_map.size() < 2) {
            passed = false;
        }
    }
    //qDebug() << "ValidateString: END " << passed;
    return passed;
}

// for user name string entries, need to expand it's usage
void UIProcess::ProcessStringMap()
{
    ProcessData Pdata;
    std::string f_name;
    std::string l_name;
    std::string filename;

    l_name = string_map.at(2);
    f_name = string_map.at(1);
    string_map.clear();

    user_data_map[static_cast<float>(1.002)] = f_name;
    user_data_map[static_cast<float>(2.002)] = l_name;

    filename = l_name + ", " + f_name;
    Pdata.SessionLog("[%s] has ended the session.", filename.c_str());

    // check and return a new filename if necessary
    filename = Pdata.CheckOutputFile(filename);
    std::string tar_directory = Pdata.StringFormat("%s/%s.txt", directory_vec.at(USER_DATA_FOLDER).c_str(), filename.c_str());

    Pdata.FileOpen(tar_directory, CREATE);

    // this gets replaced in the batch files
    std::string rCBATline = Pdata.StringFormat("7z a \"%s.docx\" \"C:\\MyProgram\\TestApp\\Form\\form_template\\*\"", filename.c_str());
    std::string rPBATline = Pdata.StringFormat("start /min WINWORD.EXE /q /n \"%s.docx\" /mFileCloseOrExit", filename.c_str());
    std::string rDBATline = Pdata.StringFormat("del /F /Q /A \"C:\\MyProgram\\Documents\\%s.docx\"", filename.c_str());

    Pdata.ChangeTargetName(directory_vec.at(COMPRESS_BAT), fCBATstring, rCBATline);
    Pdata.ChangeTargetName(directory_vec.at(PRINT_BAT), fPBATstring, rPBATline);
    Pdata.ChangeTargetName(directory_vec.at(DEL_FILES_BAT), fDBATstring, rDBATline);

    ProcessMap(filename);
}

void UIProcess::ProcessMap(std::string filename)
{
    ProcessData Pdata;
    std::map<float, std::string>::iterator it;
    std::string response;
    float page;

    for (it = response_map.begin(); it != response_map.end(); ++it) {
        page = it->first;
        response = it->second;
        user_data_map[page] = response;
    }
    Pdata.ProcessUserData(filename);
}

void UIProcess::GetFieldID(int page)
{
    int num_fields = GetNumInputFields(page);
    int field_id = 0;

    for (int i = 0; i < num_fields; ++i) {
        if (fieldID_from_pageID[i][page] != 0) {
            field_id = fieldID_from_pageID[i][page];
            fieldID_vec.push_back(field_id);
            //qDebug() << "fieldIDs " << field_id;
        }
        else {
            break;
        }
    }
    //qDebug() << "num_fields " << num_fields;
}

void UIProcess::GetTextID(int page)
{
    int num_fields = GetNumTextFields(page);
    int textfield_id = 0;

    for (int i = 0; i < num_fields; ++i) {
        if (textID_from_pageID[i][page] != 0) {
            textfield_id = textID_from_pageID[i][page];
            textfieldID_vec.push_back(textfield_id);
            //qDebug() << "fieldIDs " << field_id;
        }
        else {
            break;
        }
    }
    //qDebug() << "num_fields " << num_fields;
}


int UIProcess::GetPageID(int field_id)
{
    return fieldID_to_pageID[field_id];
}

int UIProcess::GetConfirmID(int field_id)
{
    return fieldID_to_confirmID[field_id];
}

int UIProcess::GetDataCodeID(int field_id)
{
    int data_code = 0;
    int dca_size;

    dca_size = (sizeof(datacodeID_to_fieldID)/sizeof(*datacodeID_to_fieldID));
    for (int i = 0; i < dca_size; ++i) {
        if (datacodeID_to_fieldID[i] == field_id) {
            data_code = i;
            break;
        }
    }
    //qDebug() << "data_code-size: " << data_code << "-" << dca_size;
    return data_code;
}

int UIProcess::GetNumInputFields(int page)
{
    return pageID_to_num_inputfields[page];
}

int UIProcess::GetNumTextFields(int page)
{
    return pageID_to_num_textfields[page];
}

// this needs quite a bit of work but, will work for now
int UIProcess::GetMinPageProcesses(int page)
{
    return pageID_to_num_inputfields[page];
}

int UIProcess::GetDataCodeFromFieldID(int field_id)
{
    return fieldID_to_datacodeID[field_id];
}

int UIProcess::GetFieldIDFromDataCode(int data_code)
{
    return datacodeID_to_fieldID[data_code];
}

bool UIProcess::ReplacePrevData(int confirm_status)
{
    if (confirmID_to_switch[confirm_status] == 1) {
        return true;

    }
    else {
        return false;
    }
}

int UIProcess::GetNumResponses(int field)
{
    return fieldID_to_num_responses[field];
}

void UIProcess::GetResponseIDs(int field)
{
    int num_responses = GetNumResponses(field);
    int response_id = 0;

    for (int i = 0; i < num_responses; ++i) {
        if (responseID_from_fieldID[i][field] != 0) {
            response_id = responseID_from_fieldID[i][field];
            responseID_vec.push_back(response_id);
            //qDebug() << "response_id " << response_id;
        }
        else {
            break; // stop processing, nothing in this or next element
        }
    }
    //qDebug() << "num_responses " << num_responses;
}

/*
// this isn't necessary with current implementation
void UIProcess::checkFile()
{
    ProcessData Pdata;
    std::string username;
    QString q_username;

    username = username_map.at(2) + ", ";
    username.append(username_map.at(1));

    q_username = QString::fromStdString(username);
    const char * c_username = username.c_str();

    qDebug() << "UIProcess::checkFile()";

    if (std::ifstream(Pdata.StringFormat("C:/Users/Dude/Documents/Test_programs/QtTest/documents_test/%s.txt", c_username))) {
        qDebug() << "ERROR: file already exists with name: (" << q_username << ")";
        emit badName();
    }
    else {
        emit validFile();
    }
}

// currently no use but creates a comma-delimited string
void UIProcess::processVector()
{
    QString q_response;

    for (unsigned int i = 0; i < response_vec.size(); i++) {
        q_response.append(QString::fromStdString(response_vec.at(i)));
        q_response.append(",");
    }
    qDebug() << "response = " << q_response;
    emit processedData();
}
*/
