const storiesModel = require("../../models/stories")
const globalModel = require("../../models/globalModel"),
dateTime = require('node-datetime'),
socketio = require("../../socket"),
errorCodes = require("../../functions/statusCodes"),
fieldErrors = require('../../functions/error'),
constant = require("../../functions/constant")


exports.getArchiveStories = async (req,res,next) => {
    let min_story_id = req.body.min_story_id
    let limit = 16;
    //update viewer
    await storiesModel.getArchieveStory(req,{last:min_story_id,limit:limit}).then(result => {
        let pagging = false
        let items = result
        if (result.length > limit - 1) {
            items = result.splice(0, limit - 1);
            pagging = true
        }
        res.send({ stories: items, pagging: pagging })
    })
}
exports.getMutedUsers = async (req,res,next) => {
    let min_user_id = req.body.min_user_id
    let limit = 16;
    //update viewer
    await storiesModel.getMutedUsers(req,{last:min_user_id,limit:limit}).then(result => {
        let pagging = false
        let items = result
        if (result.length > limit - 1) {
            items = result.splice(0, limit - 1);
            pagging = true
        }
        res.send({ users: items, pagging: pagging })
    })
}
exports.getViewerStories = async (req,res,next) => {
    let last = req.body.last
    let story_id = req.body.story_id

    let story = null
    //stories_muted
    await storiesModel.getStory(req,story_id).then(async res => {
        if(res){
            story = res
        }
    });
    if(!story){
        return res.send({status:0})
    }

    //update viewer
    let owner = false;
    if(req.user && story.owner_id != req.user.user_id){
        owner = req.user.user_id
    }else if(!req.user){
        owner = 0
    }
    if(owner){
        await globalModel.custom(req,"INSERT IGNORE INTO stories_users (`owner_id`,`story_id`,`creation_date`) VALUES (?,?,?)",[owner,story_id,dateTime.create().format("Y-m-d H:M:S")])
    }

    if(req.user && story.owner_id == req.user.user_id){
        await storiesModel.getStoryViewer(req,{last:last,story_id:story_id}).then(result => {
            if(result && result.length > 0){
                res.send({viewers:result});
            }else{
                res.send({})
            }
        })
    }else{
        res.send({error:1})
    }
}
exports.getStories = async (req,res,next) => {

    let limit = 16
    let ids = req.body.ids

    // let page = 1
    // if (req.body.page == '') {
    //     page = 1;
    // } else {
    //     //parse int Convert String to number 
    //     page = parseInt(req.body.page) ? parseInt(req.body.page) : 1;
    // }

    // let offset = (page - 1) * (limit - 1)

    await storiesModel.getUserStories(req,{limit:limit,ids:ids}).then(result => {
        if(result){
            let pagging = false
            let items = result
            if (result.length > limit - 1) {
                items = result.splice(0, limit - 1);
                pagging = true
            }
            res.send({ stories: items, pagging: pagging })
        }
    });
}

exports.delete = async (req,res,next) => {
    let id = req.params.id
    let story = null
    //stories_muted
    await storiesModel.getStory(req,id).then(async res => {
        if(res){
            story = res
        }
    });
    if(!story){
        return res.send({status:0})
    }
    await storiesModel.deleteStory(req,story).then(async res => {
        if(res){
            socketio.getIO().emit('deleteStory', {
                story: story,
                owner_id:req.user.user_id
            });
        }
    })

    return res.send({status:1})
}



exports.mute = async (req,res,next) => {
    let id = req.params.id
    let owner_id = req.body.owner_id

    let story = null
    //stories_muted
    if(!owner_id){
        await storiesModel.getStory(req,id).then(async res => {
            if(res){
                story = res
            }
        });
        if(!story){
            return res.send({status:0})
        }
        await globalModel.create(req,{owner_id:req.user.user_id,resource_id:story.owner_id,creation_date: dateTime.create().format("Y-m-d H:M:S")},'stories_muted').then(async res => {
            if(res){
                socketio.getIO().emit('muteStory', {
                    resource_owner: story.owner_id,
                    story_id:id,
                    owner_id:req.user.user_id
                });
            }
        })
    }else{
        await storiesModel.getMuteUser(req,owner_id).then(result => {            
            if(!result){
                globalModel.create(req,{owner_id:req.user.user_id,resource_id:owner_id,creation_date: dateTime.create().format("Y-m-d H:M:S")},'stories_muted').then(async res => {
                    socketio.getIO().emit('muteStory', {
                        resource_owner: owner_id,
                        story_id:id,
                        owner_id:req.user.user_id
                    });
                })
            }else{
                globalModel.delete(req,"stories_muted","mute_id",result.mute_id);
            }
        });
    }
    

    return res.send({status:1})
}
exports.privacy = async (req,res,next) => {
    let privacy = req.body.privacy
    let user_id = req.user.user_id

    await storiesModel.getStoryPrivacy(req,req.user.user_id).then(async res => {
        if(res){
            await globalModel.update(req,{privacy:privacy,owner_id:user_id},"stories_user_settings","setting_id",res.setting_id);
        }else{
            await globalModel.create(req,{privacy:privacy,owner_id:user_id},"stories_user_settings");
        }
    })

    

    return res.send({status:1})

}
exports.getprivacy = async (req,res,next) => {
    let privacy = "public"
    await storiesModel.getStoryPrivacy(req,req.user.user_id).then(async res => {
        if(res){
            privacy = res.privacy
        }else{
            
        }
    })

    

    return res.send({privacy:privacy})

}
exports.create = async (req,res,next) => {

    let privacy = "public"
    await storiesModel.getStoryPrivacy(req,req.user.user_id).then(async res => {
        if(res){
            privacy = res.privacy
        }else{
            
        }
    })

    let approve = req.levelPermissions["stories.auto_approve"];

    let uploadType = req.uploadType
    let insertObject = {}
    insertObject["owner_id"] = req.user.user_id
    if(req.fileName)
        insertObject["image"] = "/upload/stories/"+req.fileName
    insertObject["status"] = 1;
    insertObject["view_privacy"] = privacy

    insertObject["approve"] = approve
    if(req.body.seemore)
        insertObject["seemore"] = req.body.seemore ? req.body.seemore : ""
    insertObject["creation_date"] = dateTime.create().format("Y-m-d H:M:S")
    insertObject["modified_date"] = dateTime.create().format("Y-m-d H:M:S")

    if(uploadType == "videoStory"){
        if(!req.videoName){
            return res.send({ error: fieldErrors.errors([{ msg: constant.stories.VIDEO }], true), status: errorCodes.invalid }).end();
        }else{
            insertObject["type"] = "1"
            insertObject["file"] = "/upload/stories/"+req.videoName
        }
    }else if(uploadType == "audioStory"){
        if(!req.audioName){
            return res.send({ error: fieldErrors.errors([{ msg: constant.stories.AUDIO }], true), status: errorCodes.invalid }).end();
        }else{
            insertObject["type"] = "2"
            insertObject["file"] = "/upload/stories/"+req.audioName
        }
    }else if(uploadType == "imageStory"){
        
        if(!req.fileName){
            return res.send({ error: fieldErrors.errors([{ msg: constant.stories.IMAGE }], true), status: errorCodes.invalid }).end();
        }else{
            insertObject["type"] = "0"
        }
        
    }else if(uploadType == "textStory"){
        if(!req.body.text){
            return res.send({ error: fieldErrors.errors([{ msg: constant.stories.TEXT }], true), status: errorCodes.invalid }).end();
        }else{
            insertObject["type"] = "3"
            insertObject["description"] = req.body.text
            insertObject["text_color"] = req.body.textColor
            insertObject["background_image"] = req.body.background
            insertObject["font"] = req.body.font
        }
    }
    let story = null
    await globalModel.create(req,insertObject,"stories").then(async result => {
        if(result){
            await storiesModel.getUserStories(req,{story_id:result.insertId}).then(result => {
                if(result){
                    story = result[0]
                }
            })
            // socketio.getIO().emit('storyCreated', {
            //     story: story,
            //     story_id:id,
            //     owner_id:req.user.user_id
            // });
        }
    })

    return res.send({create:1,story:story});

}