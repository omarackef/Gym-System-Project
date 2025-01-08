*** Settings ***
Library    SeleniumLibrary
Suite Setup    Open Browser To Login Page
Suite Teardown    Close Browser

*** Variables ***
${LOGIN_URL}    file:///C:/Users/omar%20ackef/Desktop/gym-management-system/index.html  # Update this path
${BROWSER}      Chrome
${COACH_USERNAME}    NasserAley
${COACH_PASSWORD}    NasserAley
${DELAY}        1s  # Delay between steps (1 second)
${TRAINING_PLAN}    3  # Plan number for training plan
${NUTRITION_PLAN}    3  # Plan number for nutrition plan

*** Test Cases ***
Assign Plans To First Client
    Go To Login Page
    Sleep    ${DELAY}  # Pause after opening the login page
    Login As Coach
    Sleep    ${DELAY}  # Pause after logging in
    Navigate To Manage Coach Clients Page
    Sleep    ${DELAY}  # Pause after navigating to the manage clients page
    Assign Plans To First Client

*** Keywords ***
Open Browser To Login Page
    Open Browser    ${LOGIN_URL}    ${BROWSER}
    Maximize Browser Window
    Sleep    ${DELAY}  # Pause after opening the browser

Go To Login Page
    Click Element    xpath=//button[contains(text(), 'Login')]
    Sleep    ${DELAY}  # Pause after clicking the login button

Login As Coach
    Wait Until Element Is Visible    xpath=//button[contains(text(), 'Coach')]
    Click Element    xpath=//button[contains(text(), 'Coach')]  # Select Coach role
    Sleep    ${DELAY}  # Pause after selecting the coach role
    Input Text    id=username    ${COACH_USERNAME}
    Sleep    ${DELAY}  # Pause after entering the username
    Input Text    id=password    ${COACH_PASSWORD}
    Sleep    ${DELAY}  # Pause after entering the password
    Click Element    xpath=//button[contains(text(), 'Login')]
    Sleep    ${DELAY}  # Pause after clicking the login button

Navigate To Manage Coach Clients Page
    Wait Until Element Is Visible    xpath=//button[contains(text(), "Manage Your Clients' Profiles")]
    Click Element    xpath=//button[contains(text(), "Manage Your Clients' Profiles")]
    Sleep    ${DELAY}  # Pause after navigating to the manage clients page

Assign Plans To First Client
    Wait Until Element Is Visible    xpath=//tr[1]//button[contains(text(), 'Assign Plans')]
    Click Element    xpath=//tr[1]//button[contains(text(), 'Assign Plans')]  # Click "Assign Plans" for the first client
    Sleep    ${DELAY}  # Pause after clicking the "Assign Plans" button

    # Wait for the assign plans form to load
    Wait Until Element Is Visible    id=training-plan  # Ensure the training plan dropdown is visible
    Wait Until Element Is Visible    id=nutrition-plan  # Ensure the nutrition plan dropdown is visible

    # Select Training Plan 3
    Select From List By Value    id=training-plan    ${TRAINING_PLAN}
    Sleep    ${DELAY}  # Pause after selecting the training plan

    # Select Nutrition Plan 3
    Select From List By Value    id=nutrition-plan    ${NUTRITION_PLAN}
    Sleep    ${DELAY}  # Pause after selecting the nutrition plan

    # Save the changes
    Click Element    xpath=//button[contains(text(), 'Assign Plans')]  # Click the "Assign Plans" button
    Sleep    ${DELAY}  # Pause after saving changes