#ifndef UIPROCESS_H
#define UIPROCESS_H

#include <QObject>


#define NAME_CHAR "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ01234567890`~-\'. "


class UIProcess : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString ps_data1 READ ps_data1 WRITE setS_data1)        // used to send strings to the c++ side
    Q_PROPERTY(int pi_data1 READ pi_data1 WRITE setI_data1)            // used to send intergers to the c++ side
    Q_PROPERTY(int pi_data2 READ pi_data2 WRITE setI_data2)            // used to send intergers to the c++ side
    Q_PROPERTY(int pi_data3 READ pi_data3 WRITE setI_data3)            // used to send intergers to the c++ side
    Q_PROPERTY(bool pb_data1 READ pb_data1 WRITE setB_data1)           // used to send bool values to the c++ side

    /*
    // old variable usage
    Q_PROPERTY(QString c_data READ c_data WRITE setS_data1)
    Q_PROPERTY(int p_response READ p_response WRITE setI_data1)
    Q_PROPERTY(int p_question READ p_question WRITE setI_data2)
    Q_PROPERTY(int p_data_code READ p_data_code WRITE setI_data3)
    Q_PROPERTY(bool p_switch READ p_switch WRITE setB_data1)
     */

public:
    UIProcess(QObject *parent = 0);

    // UI-used variables
    QString ps_data1() const;
    void setS_data1(const QString &ps_data1);

    int pi_data1() const;
    void setI_data1(const int &pi_data1);

    int pi_data2() const;
    void setI_data2(const int &pi_data2);

    int pi_data3() const;
    void setI_data3(const int &pi_data3);

    bool pb_data1() const;
    void setB_data1(const bool &pb_data1);

        // to populate UI menus/buttons and autocomplete
    Q_INVOKABLE void sendMenuData(int page_id); // for initial menu data
    Q_INVOKABLE void checkAutoComplete(); // for text input autocompletion
    Q_INVOKABLE void sendFieldData(int page_id); // for button text/responses - will need to account for switches, etc
    Q_INVOKABLE void sendPromptData(int page_id); // sends prompt text

        // for virtual keyboard
    //Q_INVOKABLE void setVKenabled(int vk_enabled); // sets variable in UI and c++ - 0 = false; 1 = true - unused
    Q_INVOKABLE void processVKey(QString key_value); // sends signal back to UI with key value
    Q_INVOKABLE void setCaps(bool caps); // sets capitalization output
    Q_INVOKABLE void setFocus(int focus_type); // sends a signal to the UI on what to set the focus to

        // UI-used functions
    Q_INVOKABLE void checkString(); // used for text input
    Q_INVOKABLE void processClick(); // records data on each click instance
    Q_INVOKABLE void confirmData(int question); // intial data processing    
    Q_INVOKABLE void getNextData(int page); // sued to change field properties/states when navigating
    Q_INVOKABLE void getPreviousPage(int current_page); // very simple signal function to keep page navigation at stackView
    Q_INVOKABLE void processQuit(); // sole use is to log user "quit"

    // ----------  NEW_ADD_TO_TESTCLIENT_UI

    // semi-final processing functions
    bool ValidateString(int field_id);
    void ProcessStringMap();
    void ProcessMap(std::string p_filename);

    // utility functions
    bool RemoveResponse(int field_id);
    int GetPageProcesses(int field_id);
    int IsValidInput(std::string p_input, bool check_acceptable, bool check_restricted, bool check_length, const char * valid_chars, const char * invalid_chars, int min_length, int max_length);
    std::string GetStringResponse(int field_id, int num_response);

    // all of these tie in to page process, confirmation, page data population, etc
    void GetFieldID(int page);
    void GetTextID(int page);
    int GetPageID(int field_id);
    int GetConfirmID(int field_id);
    int GetDataCodeID(int field_id);
    int GetFieldIDFromDataCode(int data_code);
    int GetDataCodeFromFieldID(int field_id);
    int GetNumInputFields(int page);
    int GetNumTextFields(int page);
    int GetMinPageProcesses(int page);
    bool ReplacePrevData(int confirm_status);
    int GetNumResponses(int field);
    void GetResponseIDs(int field);

    // for UI data tranfer - variables passed must have the same name in the UI to use the data - combine and rename these where necessary
signals:
        // for virtual keyboard
    //void setVKenable(int n_data);
    void sendKeyToField(int n_data, QString str_data); // send VKeyboard touch emission to the data field in the UI
    void sendFocusType(int s_data);                 // sends focus type command to set focus

        // to populate menus/buttons and autocomplete
    void sendWords(int d_data, QString str_data);   // sends data_code/words for auto-complete
    void sendWordCount(int n_data, int s_data);     // sends word_count/field_id as header - (field_id, w_count)
    void sendToField(int n_data, int s_data, QString str_data);   // sends button text labels/responses (field_id, responseID, response_string)
    void sendToPrompt(int n_data, QString str_data);   // sends field text (textID, text)

// ----------  NEW_ADD_TO_TESTCLIENT_UI

    // affects navigation
    void previousPage(int n_data);                  // very simple signal to keep page navigation at stackView
    void validData(int n_data);                     // used on each page to signal data acceptance and navigation choice, returns next page#
    void processedData();                           // used to signal program closure
    void noData();                                  // no data recorded, error popup
    void invalidData();                             // no data recorded, error popup with specific text

    // UI state change signals
    void stringData(QString str_data, int str_pos); // used to send string data when navigating back/forward to fill textedit fields - behaves funny
    void changeState(int s_data, bool f_switch); // used to change button properties when only a single state change is required
    void dataCode(int n_data, int s_data); // used to send click data_code when next clicked to change button properties/states if navigating back/forward

    // these are used specifically for data sent from the UI - transfer data to a different variable quickly
private:
    QString s_data1;
    int i_data1;
    int i_data2;
    int i_data3;
    bool b_data1;

    // currently unused functions - possibly deprecated
    //Q_INVOKABLE void checkFile();
    //Q_INVOKABLE void processVector(); // currently no use but creates a comma-delimited string

    // currently unused signals - possibly deprecated
    //void validFile(); // was used when user actions generated a file during program usage

};

extern std::map<float, std::string> user_data_map;

#endif // UIPROCESS_H
