*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Test Setup    Open Browser    ${url}    ${browser}   #ใช้ Test Setup เนื่องจากมันจะเปิด browser ใหม่ทุกเทสเคส
#Suite Setup    Open Browser    ${url}    ${browser}


*** Variables ***
${browser}    chrome
${url}    https://qaplayground.dev/apps/verify-account/
#${input_box}  xpath=//input[@type='number']
#${success}  xpath=//small[contains(@class, 'info success')]


*** Keywords ***
Input Nine
    Input Text    ${input_box}    9
Input Four
    Input Text    ${input_box}    4
   

*** Test Cases ***
Input the correct code
    FOR    ${i}    IN RANGE    1    7
        ${locator}=    Set Variable    xpath=(//input[@type='number'])[${i}]
        Input Text    ${locator}    9
    END
    Wait Until Element Is Visible    xpath=//small[contains(@class, 'info success')]    timeout=5
    Log    Success message is visible
    Sleep    2s
Input the incorrect code
    FOR    ${i}    IN RANGE    1    7
        ${locator}=    Set Variable    xpath=(//input[@type='number'])[${i}]
        Input Text    ${locator}    4
    END
    Wait Until Element Is Not Visible    xpath=//small[contains(@class, 'info success')]    timeout=5
    Log    Success message is not visible
    Sleep    2s

Input the correct code with เลข 4 และเลข 9 ผสมกัน
    FOR    ${i}    IN RANGE    1    7    # ทำลูป 6 รอบ (ช่องที่ 1 ถึง 6)
        ${locator}=    Set Variable    xpath=(//input[@type='number'])[${i}]
        ${value}=      Evaluate    9 if ${i} % 2 == 1 else 4     #หาเลขคู่เลขคี่
        Input Text    ${locator}    ${value}
    END
    Wait Until Element Is Not Visible    xpath=//small[contains(@class, 'info success')]    timeout=5
    Log    Success message is not visible
    Sleep    2s




