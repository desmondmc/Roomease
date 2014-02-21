
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:
Parse.Cloud.define("hello", function(request, response) {
  response.success("Hello world!");
});

Parse.Cloud.afterSave("House", function(request, response) {
                      //TODO need to check if this is the first user moving into the house.
//                      var users = request.object.get("users");
//                      Array(users);
//                      if (users.length == 1)
//                      {
//                        Parse.User.current().set("home", request.object);
//                        Parse.User.current().save();
//                      }
                       Parse.User.current().set("home", request.object);
                       Parse.User.current().save();
});

Parse.Cloud.afterSave(Parse.User, function(request, response) {
                      console.log("Running after save on user!");
                      var House = Parse.Object.extend("House");
                      var house = new House;
                      house = Parse.User.current().get("home");
                      
                      house.fetch({
                                     success: function(myObject) {
                                     // The object was refreshed successfully.
                                        var houseName = house.get("name");
                                        console.log("Sending push to House: " + houseName);
                                  
                                  Parse.Push.send({
                                                  channels: [ houseName ],
                                                  data: {
                                                    alert: "asdasd",
                                                    "content-available": "1",
                                                    "acme1" : "bar"
                                                  }
                                                  }, {
                                                  success: function() {
                                                  // Push was successful
                                                  console.log("Sent push!");
                                                  },
                                                  error: function(error) {
                                                  // Handle error
                                                  console.log("Error sending push! Error: " + error);
                                                  }
                                                  });
                                     },
                                     error: function(myObject, error) {
                                     // The object was not refreshed successfully.
                                     // error is a Parse.Error with an error code and description.
                                        console.log("Failed to fetch house");
                                     }
                                     });
                      

                      
});
