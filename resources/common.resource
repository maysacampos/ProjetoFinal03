# Settings e Keywords
*** Settings ***
Library    RequestsLibrary


*** Keywords ***
Create Token
    [Arguments]    ${url}

    ${body}    Create Dictionary    username=admin    password=password123
    ${response}    POST    url=${url}/auth    json=${body}   

    Status Should Be    200
    ${token}    Set Variable    ${response.json()}[token]
    Set Suite Variable    ${token}
    Log To Console    ${token}

Get Booking Id
    [Arguments]    ${url}    ${firstname}    ${lastname}

    ${response}    GET    url=${url}/booking?firstname=${firstname}&lastname=${lastname}
    
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}
    
    Status Should Be    200

    ${booking_id}    Set Variable    ${response_body}[0][bookingid]
    Set Suite Variable    ${booking_id}

Create User   
    [Arguments]    ${url}    ${username}    ${password}
    ${headers}    Create Dictionary    Content-Type=${content_type}    
    ${body}    Create Dictionary    userName=${username}    password=${password}  

    ${response}    POST    url=${url}/Account/v1/User    json=${body}    
     ...    headers=${headers}

    Status Should Be    201    
    ${userId}    Set Variable    ${response.json()}[userID]
    Set Suite Variable    ${userId}                          
    Log to Console    ${userId}

Create Bearer
    [Arguments]    ${url}    ${userName}    ${password}   

    ${body}    Create Dictionary    userName=${userName}    password=${password}
    ${response}    POST    url=${url}/Account/v1/GenerateToken    json=${body}

    Status Should Be    200
    ${bearer}    Set Variable    ${response.json()}[token]
    Set Suite Variable    ${bearer} 
    Log To Console    ${bearer}      

Create Authorized
    [Arguments]    ${url}    ${userName}    ${password}

    ${body}    Create Dictionary    userName=${userName}    password=${password}
    ${response}    POST    url=${url}/Account/v1/Authorized    json=${body}

    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}    ${{bool(True)}}

Delete User   
    [Arguments]    ${url}    ${userName}    ${password}
    ${headers}    Create Dictionary    Content-Type=${content_type}  
    ...    Authorization=Bearer ${bearer}  
    ${body}    Create Dictionary    userId=${userId}

    ${response}    DELETE    url=${url}/Account/v1/User/${userId}    json=${body}    
     ...    headers=${headers}
    
    Status Should Be    204
    Log To Console    ${response}

Run Requirements
    [Arguments]    ${url}    ${userName}    ${password}
    Create User    ${url}    ${userName}    ${password}
    Create Bearer    ${url}   ${userName}    ${password}
    Create Authorized    ${url}    ${userName}    ${password}
