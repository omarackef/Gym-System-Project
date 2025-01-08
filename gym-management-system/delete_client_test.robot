*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser To Login Page
Suite Teardown    Close Browser

*** Variables ***
${LOGIN_URL}    file:///C:/Users/omar%20ackef/Desktop/gym-management-system/index.html  # Update this path
${BROWSER}      Chrome
${ADMIN_USERNAME}    omar
${ADMIN_PASSWORD}    omar
${DELAY}        1s  # Delay between steps (1 second)

*** Test Cases ***
Delete Client
    Go To Login Page
    Sleep    ${DELAY}  # Pause after opening the login page
    Login As Admin
    Sleep    ${DELAY}  # Pause after logging in
    Navigate To Manage Clients Page
    Sleep    ${DELAY}  # Pause after navigating to the manage clients page
    Scroll To Right To Reveal Delete Button
    Sleep    ${DELAY}  # Pause after scrolling
    Delete First Client

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    ${DELAY}  # Pause after opening the browser

Go To Login Page
    Click Element    xpath=//button[contains(text(), 'Login')]
    Sleep    ${DELAY}  # Pause after clicking the login button

Login As Admin
    Wait Until Element Is Visible    xpath=//button[contains(text(), 'Admin')]
    Click Element    xpath=//button[contains(text(), 'Admin')]
    Sleep    ${DELAY}  # Pause after selecting the admin role
    Input Text    id=username    ${ADMIN_USERNAME}
    Sleep    ${DELAY}  # Pause after entering the username
    Input Text    id=password    ${ADMIN_PASSWORD}
    Sleep    ${DELAY}  # Pause after entering the password
    Click Element    xpath=//button[contains(text(), 'Login')]
    Sleep    ${DELAY}  # Pause after clicking the login button

Navigate To Manage Clients Page
    Wait Until Element Is Visible    xpath=//button[contains(text(), 'Manage Client Profiles')]
    Click Element    xpath=//button[contains(text(), 'Manage Client Profiles')]
    Sleep    ${DELAY}  # Pause after navigating to the manage clients page

Scroll To Right To Reveal Delete Button
    Execute JavaScript    window.scrollTo(500, 0)  # Adjust the scroll value as needed
    Sleep    ${DELAY}  # Pause after scrolling

Delete First Client
    Wait Until Element Is Visible    xpath=//tr[1]//button[contains(text(), 'Delete')]
    Click Element    xpath=//tr[1]//button[contains(text(), 'Delete')]
    Sleep    ${DELAY}  # Pause after clicking the delete button
    Handle Alert    action=ACCEPT  # Accept the confirmation dialog
    Sleep    ${DELAY}  # Pause after handling the alert