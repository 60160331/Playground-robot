*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Test Setup    Open Browser    ${url}    ${browser}   #ใช้ Test Setup เนื่องจากมันจะเปิด browser ใหม่ทุกเทสเคส
#Suite Setup    Open Browser    ${url}    ${browser}


*** Variables ***
${browser}    chrome
${url}    https://qaplayground.dev/apps/dynamic-table/
${spider}   xpath=//div[contains(@class, 'text-sm') and contains(@class, 'font-medium') and contains(text(), 'Spider-Man')]
${HERO_NAME}   Spider-Man
#${REAL_NAME}   Peter Parker



*** Test Cases ***
Check ว่าใน Spider man ชื่อ Peter Parker 
    ${realname}=    Get Text    xpath=//div[contains(text(), '${HERO_NAME}')]/ancestor::tr//span[@class='text-sm font-medium text-white-900']
    # ตรวจสอบว่าชื่อจริงคือ Peter Parker
    Should Be Equal As Strings    ${realname}    Peter Parker

