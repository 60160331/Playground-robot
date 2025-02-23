*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    Collections
Suite Setup    Open Browser    ${url}    ${browser}

*** Variables ***
${browser}    chrome
${url}    https://qaplayground.dev/apps/range-slider/
${slider_bar}  xpath=//input[@type='range']
${slider_handles}  xpath=//div[@class='thumb']
${feedback_btn}   xpath=//button[@id='feedback' and contains(text(),'Send Feedback')] 

*** Keywords ***
#Open range-slider page
    #Open Browser    ${url}    ${browser} 
Move Slider To Maximum
    [Documentation]    เลื่อน Slider ไปยังค่าสูงสุด
    ${slider}=    Get WebElement    ${slider_bar}
    Drag And Drop By Offset    ${slider}    200    0   #จริงๆ MAx คือ 100 แต่ว่ามันเลื่อนได้แค่ 90 เลยใส่ไปเลย 200 ยังไงก็เลื่อนไม่ถึงอยู่แล้ว
    Sleep    5s  # ให้เวลาสำหรับการเลื่อน

Move Slider To Minimum
    [Documentation]    เลื่อน Slider ไปยังค่าต่ำสุด
    ${slider}=    Get WebElement    ${slider_bar}
    Drag And Drop By Offset    ${slider}    -200    0   #จริงๆ MAx คือ 100 แต่ว่ามันเลื่อนได้แค่ 90 เลยใส่ไปเลย 200 ยังไงก็เลื่อนไม่ถึงอยู่แล้ว
    Sleep    5s  # ให้เวลาสำหรับการเลื่อน

Verify Slider Moved To Maximum
    [Documentation]    ตรวจสอบว่า Slider เลื่อนไปยังค่าสูงสุด
    ${max_value}=    Get Element Attribute    ${slider_bar}    max
    ${current_value}=    Get Element Attribute    ${slider_bar}    value
    Should Be Equal    ${current_value}    ${max_value}    Slider value does not match Maximum value

Verify Slider Moved To Minimum
    [Documentation]    ตรวจสอบว่า Slider เลื่อนไปยังค่าต่ำสุด
    ${min_value}=    Get Element Attribute    ${slider_bar}    min
    ${current_value}=    Get Element Attribute    ${slider_bar}    value
    Should Be Equal    ${current_value}    ${min_value}    Slider value does not match Minimum value



*** Test Cases ***
Verify Range Slider Is Displayed On The Page
    [Documentation]    ตรวจสอบว่า Range Slider แสดงอยู่บนหน้าเว็บ
    #Open range-slider page
    Wait until Element Is Visible   ${slider_bar}   10s
    Element Should Be Visible    ${slider_bar}

ตรวจสอบว่ามี Slider Handles (ตัวจับเลื่อน)
    [Documentation]    ในโค้ดตัวจับเลื่อนมี style = left: ตามด้วย % (%0 = ขวาสุด : %100 = ซ้ายสุด)
    Element Should Be Visible    ${slider_handles}

ตรวจสอบ Max และ Min ของ range
    [Documentation]    ตรวจสอบว่า min และ max ของ range ถูกต้อง
        #<input type="range" min="0" value="0" max="100">
    ${range_min}=    Get Element Attribute   ${slider_bar}   min
    Log    Max value: ${range_min}
    Should Be Equal As Integers    ${range_min}    0    Slider min must be 0

    ${range_max}=    Get Element Attribute    ${slider_bar}    max
    Log    Max value: ${range_max}
    Should Be Equal As Integers    ${range_max}    100    Slider max must be 100
    Sleep    5s 
    
Verify Slider Can Be Moved To Maximum Value
    [Documentation]    ตรวจสอบว่า Slider สามารถเลื่อนไปยังค่าสูงสุดได้สำเร็จ
    # เลื่อน Slider ไปยังค่าสูงสุด
    Maximize Browser Window
    Move Slider To Maximum

    # ตรวจสอบว่าค่า Slider เป็นค่าสูงสุด
    ${max_value}=    Get Element Attribute    ${slider_bar}    max
    Log    Max value: ${slider_bar}
    ${current_value}=    Get Element Attribute    ${slider_bar}    value
    Should Be Equal    ${current_value}    ${max_value}    Slider value does not match maximum value

Verify Slider Can Be Moved To Minimun Value  
    [Documentation]    ตรวจสอบว่า Slider สามารถเลื่อนจากค่าสูงสุดมาต่ำสุดได้สำเร็จ
    Maximize Browser Window
     # เลื่อน Slider ไปยังค่าสูงสุด
    Move Slider To Maximum
     # เลื่อน Slider ไปยังต่ำสุด
    Move Slider To Minimum
    ${min_value}=    Get Element Attribute    ${slider_bar}    min
    Log    min value: ${slider_bar}
    ${current_value}=    Get Element Attribute    ${slider_bar}    value
    Should Be Equal    ${current_value}    ${min_value}    Slider value does not match Minimum value

Verify Slider Moves Back and Forth Multiple Times
    [Documentation]    ตรวจสอบว่า Slider สามารถเลื่อนจากสูงสุดไปต่ำสุดและกลับไปกลับมาหลายรอบได้
    [Tags]    slider_test    regression    smoke
    Maximize Browser Window

    FOR    ${i}    IN RANGE    0    5    # ทำลูป 5 รอบ (จาก 0 ถึง 4)
        Move Slider To Maximum
        Verify Slider Moved To Maximum
        Move Slider To Minimum
        Verify Slider Moved To Minimum
    END

Verify ว่าถ้าเลื่อนไปถึง 40% ขึ้นไปจะมีปุ่ม feedback แสดงขึ้นมา
    [Documentation]    เลื่อน Slider ไปยังค่าสูงสุดโดยใช้ JavaScript ผ่าน XPath
    Execute Javascript    var slider = document.evaluate("//input[@type='range']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; slider.value = 40; slider.dispatchEvent(new Event('input'));
    Sleep    2s

    ${current_value}=    Get Element Attribute    ${slider_bar}    value
    Log    Current Slider Value: ${current_value}
    Should Be Equal As Integers    ${current_value}    40    Slider value does not match maximum value

    #Should Contain    ${feedback_btn}   Send Feedback    The list does not contain 'Send Feedback'
    Element Should Be Visible    ${feedback_btn}    The feedback button is not visible

Verify ว่าถ้าเลื่อนไปต่ำกว่า 40% ลงไปจะไม่มีปุ่ม feedback แสดงขึ้นมา
    [Documentation]    เลื่อน Slider ไปยังค่าสูงสุดโดยใช้ JavaScript ผ่าน XPath
    Execute Javascript    var slider = document.evaluate("//input[@type='range']", document, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue; slider.value = 39; slider.dispatchEvent(new Event('input'));
    Sleep    2s

    ${current_value}=    Get Element Attribute    ${slider_bar}    value
    Log    Current Slider Value: ${current_value}
    Should Be Equal As Integers    ${current_value}    39    Slider value does not match maximum value

    #Should Not Contain    ${feedback_btn}   Send Feedback    The list does not contain 'Send Feedback'
    Element Should Not Be Visible    ${feedback_btn}    The button contains 'Feedback'




    
   