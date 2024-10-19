# Settings e Keywords
*** Settings ***
Library    RequestsLibrary
Variables    C:\ITERASYS\ProjetoFinal03\resources\variables.py
Library    OperatingSystem
Library    Collections

*** Keywords ***

Create User
    [Arguments]    ${url}    ${userName}    ${password}
    ${body}    Create Dictionary    userName=${userName}    password=${password}  
    ${response}    POST    ${url}/Account/v1/User    json=${body}  
    Status Should Be    201    
    ${userId}    Set Variable    ${response.json()}[userID]
    Set Suite Variable    ${userId}                          
    Log To Console    ${userId}

Create Bearer
    [Arguments]    ${url}    ${userName}    ${password}
    ${body}    Create Dictionary    userName=${userName}    password=${password}
    ${response}    POST    ${url}/Account/v1/GenerateToken    json=${body}
    Status Should Be    200
    ${bearer}    Set Variable    ${response.json()}[token]
    Set Suite Variable    ${bearer}    
    Log To Console    ${bearer}

Create Book
    [Arguments]    ${url}    ${book_json_path}    ${userId}    ${bearer}
    ${headers}    Create Dictionary    Content-Type=application/json    
    ...    Authorization=Bearer ${bearer}
    ${body}    Evaluate    json.loads(open("${book_json_path}").read())
    Set To Dictionary    ${body}    userId=${userId}

    ${response}    POST    ${url}/BookStore/v1/Books    json=${body}    
    ${response_body}    Set Variable    ${response.json()}  
    Log To Console    ${response_body}
    Status Should Be    201

Create Authorized
    [Arguments]    ${url}    ${userName}    ${password}

    ${body}    Create Dictionary    userName=${userName}    password=${password}
    ${response}    POST    url=${url}/Account/v1/Authorized    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}    ${{bool(True)}}

