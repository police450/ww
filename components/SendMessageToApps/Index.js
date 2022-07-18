const Index = ({props,type,theme}) => {
    // iOS app work
    if(!props.pageData.fromAPP){
        return null;
    }
    if(props.pageData.fromAppDevice == "ios"){
        try {
            window.webkit.messageHandlers[type].postMessage(
            {
                user:props.pageData.loggedInUserDetails,
                purchaseData:props.purchaseData,
                theme:theme
            });
        } catch(err) {
            console.log(err,' error');
        }
    }
};

export default Index;