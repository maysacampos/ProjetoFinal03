*** Settings ***
Library        RequestsLibrary
Library        OperatingSystem
Library        Collections

Resource       ../../resources/common.resource
Variables      ../../resources/variables.py


*** Variables ***
${isbn}    9781449325862
${BOOK_JSON_PATH}    ./fixtures/book.json
${url}    https://bookstore.toolsqa.com
${userName}    User6
${password}    @Password123

*** Test Cases ***

Create Book
    [Documentation]    Cria um novo livro na loja.
    ${userName}    Set Variable    User6
    ${password}    Set Variable    @Password123
    Create User    ${url}    ${userName}    ${password}
    Create Bearer    ${url}    ${userName}    ${password}
    
    ${headers}    Create Dictionary    Content-Type=${content_type}    
    ...    Authorization=Bearer ${bearer}
    ${body}    Evaluate    json.loads(open("${BOOK_JSON_PATH}").read())
    Set To Dictionary    ${body}    userId=${userId}

    ${response}    POST    ${url}/BookStore/v1/Books    json=${body}    
    ${response_body}    Set Variable    ${response.json()}  
    Log To Console    ${response_body}
    Status Should Be    201

Get Book
    ${headers}    Create Dictionary    Content-Type=${content_type}    
    ${response}    GET    url=${url}/BookStore/v1/Book?ISBN=${isbn}
    ${response_body}    Set Variable    ${response.json()}
    Log To Console    ${response_body}

    Status Should Be    200
    Should Be Equal    ${response_body}[isbn]            9781449325862
    Should Be Equal    ${response_body}[title]           Git Pocket Guide
    Should Be Equal    ${response_body}[subTitle]        A Working Introduction
    Should Be Equal    ${response_body}[author]          Richard E. Silverman
    Should Be Equal    ${response_body}[publisher]       O'Reilly Media
    Should Be Equal    ${response_body}[pages]           ${{int(234)}}
    Should Be Equal    ${response_body}[description]     This pocket guide is the perfect on-the-job companion to Git, the distributed version control system. It provides a compact, readable introduction to Git for new users, as well as a reference to common commands and procedures for those of you with Git exp    
    Should Be Equal    ${response_body}[website]         http://chimera.labs.oreilly.com/books/1230000000561/index.html
