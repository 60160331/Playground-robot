*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections

*** Variables ***
${browser}    chrome
${url}    https://studentsafephp.su8.ecoachmanager.com/admin/#!login.php
${btn_login}   xpath=//input[@type='submit' and contains(@class, 'btn')]
${user_name}  Kit
${correct_password}  Kit30124280941/2
${wrong_user_name}  Kitt
${wrong_password}   Kit30124280941&
${username_field}    name=name
${password_field}    name=p
${error_message}    xpath=//div[@id='box-result' and contains(@class, 'bg-red')]
${success_message}    xpath=//div[@id='box-result' and contains(@class, 'bg-green')]


*** Keywords ***
เปิดเว็บ SS UK UAT
    Open Browser    ${url}    ${browser}

Enter wrong password
    Wait Until Element Is Visible    ${username_field}    10s
    Input Text    ${username_field}    ${user_name}
    Input Text    ${password_field}    ${wrong_password}
    Click Element    ${btn_login}
    # รอให้ข้อความแสดงขึ้นหลังจากล็อกอินผิด
    Wait Until Element Is Visible    ${error_message}    10s
    # ดึงข้อความใหม่หลังจากหน้าเว็บโหลด
    ${error_text}=    Get Text    ${error_message}
    Should Contain    ${error_text}    Incorrect Password or Username
Enter wrong username
    Wait Until Element Is Visible    ${username_field}    10s
    Input Text    ${username_field}    ${wrong_user_name}
    Input Text    ${password_field}    ${correct_password}
    Click Element    ${btn_login}
    # รอให้ข้อความแสดงขึ้นหลังจากล็อกอินผิด
    Wait Until Element Is Visible    ${error_message}    10s
    # ดึงข้อความใหม่หลังจากหน้าเว็บโหลด
    ${error_text}=    Get Text    ${error_message}
    Should Contain    ${error_text}    Incorrect Password or Username
Enter correct username and password
    Wait Until Element Is Visible    ${username_field}    10s
    Input Text    ${username_field}    ${user_name}
    Input Text    ${password_field}    ${correct_password}
    Click Element    ${btn_login}
    
    ${popup_status}=    Run Keyword And Return Status    Handle Alert    ACCEPT
    Log    Popup Status: ${popup_status}
    Run Keyword If    ${popup_status}
    ...    Log    Alert was handled successfully.
    ...    ELSE
    ...    Wait Until Element Is Visible    ${success_message}    10s
    ${success_text}=    Get Text    ${success_message}
    Should Contain    ${success_text}    Success


*** Test Cases ***
Verify can be login
    เปิดเว็บ SS UK UAT
    Sleep    5s
Verify Login fail from wrong Password
    Enter wrong password
    Sleep    5s
Verify Login fail from wrong username
    Enter wrong username
    Sleep    5s
Verify can be login
    Enter correct username and password
    Sleep    5s

