try {
    JSON.stringify(jsonlint.parse(%s),null,"  ");
}catch(e){
    console.log(" ");
    console.log("********** Invalid JSON **********");
    console.log(e);
    console.log(" ");
}
