
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.afterSave("House", function(request, response) {
    //TODO need to check if this is the first user moving into the house.
    Parse.User.current().set("home", request.object);
    Parse.User.current().save();
});
