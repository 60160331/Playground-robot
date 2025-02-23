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
${username_field}    name=name
${password_field}    name=p
${success_message}    xpath=//div[@id='box-result' and contains(@class, 'bg-green')]
${user_menu}   xpath=//span[contains(text(), 'Kit')]/i[@class='caret']
${sign_out_button}    xpath=//a[@class='btn btn-default btn-flat' and @href='https://studentsafephp.su8.ecoachmanager.com/admin?page=logout']

*** Keywords ***
เปิดเว็บ SS UK UAT
    Open Browser    ${url}    ${browser}

Login
    Wait Until Element Is Visible    ${username_field}    10s
    Input Text    ${username_field}    ${user_name}
    Input Text    ${password_field}    ${correct_password}
    Click Element   ${btn_login}
    
    ${popup_status}=    Run Keyword And Return Status    Handle Alert    ACCEPT
    Log    Popup Status: ${popup_status}
    Run Keyword If    ${popup_status}
    ...    Log    Alert was handled successfully.
    ...    ELSE
    ...    Wait Until Element Is Visible    ${success_message}    10s
    ${success_text}=    Get Text    ${success_message}
    Should Contain    ${success_text}    Success
Logout
    Wait Until Element Is Visible    ${user_menu}    120s
    Click Element   ${user_menu}
    Wait Until Element Is Enabled    ${sign_out_button}    10s  
    Click Element   ${sign_out_button}
    
*** Test Cases ***
Verify can be logout
    เปิดเว็บ SS UK UAT
    login
    Logout 




