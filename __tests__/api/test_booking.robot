# *** Variables *** ---> resources/variables.py
# *** Settings ***  ---> resources/common.resource
# *** Test Cases *** ---> Continuam no arquivo .robot
# *** Keywords ***  ---> resources/common.resource


*** Settings ***
Library        RequestsLibrary
Resource       ../../resources/common.resource
Variables      ../../resources/variables.py
Suite Setup    Create Token    ${url}         

*** Variables ***
${isbn}    9781449325862

*** Test Cases ***
Create Booking
  
    ${headers}    Create Dictionary    Content-Type=${content_type}
    ${body}    Evaluate    json.loads(open('./fixtures/json/booking1.json').read())

    ${response}    POST    url=${url}/booking    json=${body} 
    ...    headers=${headers}
    
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[booking][firstname]          ${firstname}
    Should Be Equal    ${response_body}[booking][lastname]           ${lastname}
    Should Be Equal    ${response_body}[booking][totalprice]         ${totalprice}
    Should Be Equal    ${response_body}[booking][depositpaid]        ${depositpaid}
    Should Be Equal    ${response_body}[booking][bookingdates][checkin]     
    ...                                       ${bookingdates}[checkin]
    Should Be Equal    ${response_body}[booking][bookingdates][checkout]     
    ...                                       ${bookingdates}[checkout]
    Should Be Equal    ${response_body}[booking][additionalneeds]    ${additionalneeds}
    

Get Book
    ${headers}    Create Dictionary    Content-Type=${content_type}    
    ${response}    GET    url=${url}/BookStore/v1/Book?ISBN=${isbn}
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[title]    Chris
    Should Be Equal    ${response_body}[subTitle]    Brown
    Should Be Equal    ${response_body}[author]    Richard E. Silverman
    Should Be Equal    ${response_body}[publisher]    O'Reilly Media
    Should Be Equal    ${response_body}[pages]    ${{int(234)}}
    Should Be Equal    ${response_body}[description]    This pocket guide is the perfect on-the-job companion to Git,
    ...    the distributed version control system. It provides a compact, readable introduction to Git for new users,
    ...    as well as a reference to common commands and procedures for those of you with Git exp    
