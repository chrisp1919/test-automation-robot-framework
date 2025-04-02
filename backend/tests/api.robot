*** Settings ***
Library    RequestsLibrary

*** Test Cases ***
Verify Get Request
    ${response}=  GET  http://proxy/health  expected_status=200

#Verify Post Request
#    ${headers}=  Create Dictionary  Content-Type=application/json
#    ${response}=  POST  http://proxy/articles/  data={"title":"test","content":"test"}  headers=${headers}  expected_status=201

Pobranie listy artykułów dwukrotnie i sprawdzenie, że liczba artykułów się nie zmieniła
    ${response1}=  GET  http://proxy/articles/  expected_status=200
    ${response2}=  GET  http://proxy/articles/  expected_status=200
    ${json1}=    Evaluate    json.dumps(${response1.json()}, sort_keys=True)    json
    ${json2}=    Evaluate    json.dumps(${response2.json()}, sort_keys=True)    json
    Should Be Equal    ${json1}    ${json2}

Pobranie listy artkułów i sprawdzenie, że nie ma tam artykułu Y
    ${response}=    GET    http://proxy/articles/    expected_status=200
    ${articles}=    Set Variable    ${response.json()}
    ${titles}=    Evaluate    [a["title"] for a in ${articles}]    json
    Should Not Contain  ${titles}  Y

Dodanie artykułu Y
    ${headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  POST  http://proxy/articles/  data={"title":"Y","content":"test"}  headers=${headers}

Pobranie listy artykułów i sprawdzenie, że artykuł Y jest na liście
    ${response}=    GET    http://proxy/articles/    expected_status=200
    ${articles}=    Set Variable    ${response.json()}
    ${titles}=    Evaluate    [a["title"] for a in ${articles}]    json
    Should Contain  ${titles}  Y

Usunięcie artykułu Y
    ${response}=    GET    http://proxy/articles/    expected_status=200
    ${articles}=    Set Variable    ${response.json()}
    ${found}=    Evaluate    next((a for a in ${articles} if a["title"] == 'Y'), None)    json
    DELETE  http://proxy/articles/${found['id']}  expected_status=204

Pobranie listy artkułów i sprawdzenie, że nie ma tam artykułu Y
    ${response}=    GET    http://proxy/articles/    expected_status=200
    ${articles}=    Set Variable    ${response.json()}
    ${titles}=    Evaluate    [a["title"] for a in ${articles}]    json
    Should Not Contain  ${titles}  Y

Próba usunięcia nieistniejącego artykułu i sprawdzenie, że zwrócony został błąd 404
    ${response}=  DELETE  http://proxy/articles/noexistent  expected_status=404

Próba dodania artykułu bez tytułu i sprawdzenie, że zwrócony został błąd 400 wraz ze stosowną informacją
    ${headers}=  Create Dictionary  Content-Type=application/json
    ${response}=  POST  http://proxy/articles/  data={"content":"test"}  headers=${headers}  expected_status=400
