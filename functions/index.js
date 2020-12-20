const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();


exports.onCreateFollower = functions.firestore
  .document("/followers/{restId}/userFollowers/{followerId}")
  .onCreate(async (snapshot, context) => {

    console.log("Follower Created", snapshot.id);

    const restId = context.params.restId;

    const followerId = context.params.followerId;

    const followedUserPostsRef = admin
      .firestore()
      .collection("meals")
      .doc(restId)
      .collection("mealList");

    const timelinePostsRef = admin
      .firestore()
      .collection("timeline")
      .doc(followerId)
      .collection("timelinePosts");

    const querySnapshot = await followedUserPostsRef.get();

    querySnapshot.forEach(doc => {
      if (doc.exists) {
        const mealId = doc.id;
        const mealData = doc.data();
        timelinePostsRef.doc(mealId).set(mealData);
      }
    });
  });


  exports.onDeleteFollower = functions.firestore
  .document("/followers/{restId}/userFollowers/{followerId}")
  .onDelete(async (snapshot, context) => {

    console.log("Follower Deleted", snapshot.id);

    const restId = context.params.restId;

    const followerId = context.params.followerId;

    const timelinePostsRef = admin
      .firestore()
      .collection("timeline")
      .doc(followerId)
      .collection("timelinePosts")
      .where("ownerId", "==", restId);

    const querySnapshot = await timelinePostsRef.get();
    querySnapshot.forEach(doc => {
      if (doc.exists)
      {
        doc.ref.delete();
      }
    });
  });


exports.onCreatePost = functions.firestore
  .document("/meals/{restId}/mealList/{mealId}")
  .onCreate(async (snapshot, context) => {

    const mealCreated = snapshot.data();

    const restId = context.params.restId;

    const mealId = context.params.mealId;

    const userFollowersRef = admin
      .firestore()
      .collection("followers")
      .doc(restId)
      .collection("userFollowers");

    const querySnapshot = await userFollowersRef.get();

    querySnapshot.forEach(doc => {
      const followerId = doc.id;

      admin
        .firestore()
        .collection("timeline")
        .doc(followerId)
        .collection("timelinePosts")
        .doc(mealId)
        .set(mealCreated);
    });
  });


exports.onUpdatePost = functions.firestore
  .document("/meals/{restId}/mealList/{mealId}")
  .onUpdate(async (change, context) => {
    const mealUpdated = change.after.data();
    const restId = context.params.restId;
    const mealId = context.params.mealId;

    const userFollowersRef = admin
      .firestore()
      .collection("followers")
      .doc(restId)
      .collection("userFollowers");

    const querySnapshot = await userFollowersRef.get();

    querySnapshot.forEach(doc => {
      const followerId = doc.id;

      admin
        .firestore()
        .collection("timeline")
        .doc(followerId)
        .collection("timelinePosts")
        .doc(mealId)
        .get()
        .then(doc => {
          if (doc.exists) {
            doc.ref.update(mealUpdated);
          }
        });
    });
  });


exports.onDeletePost = functions.firestore
  .document("/meals/{restId}/mealList/{mealId}")
  .onDelete(async (snapshot, context) => {
    const restId = context.params.restId;
    const mealId = context.params.mealId;

    const userFollowersRef = admin
      .firestore()
      .collection("followers")
      .doc(restId)
      .collection("userFollowers");

    const querySnapshot = await userFollowersRef.get();

    querySnapshot.forEach(doc => {
      const followerId = doc.id;

      admin
        .firestore()
        .collection("timeline")
        .doc(followerId)
        .collection("timelinePosts")
        .doc(mealId)
        .get()
        .then(doc => {
          if (doc.exists) {
            doc.ref.delete();
          }
        });
    });
  });
