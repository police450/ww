import React from "react"

import Items from "./SettingsMenuItems"

class SettingMenus extends React.Component{
    constructor(props){
        super(props)
        this.state = {
            style:"none",
            type:props.type
        }
    }
    
    static getDerivedStateFromProps(nextProps, prevState) {
        if(typeof window == "undefined" || nextProps.i18n.language != $("html").attr("lang")){
            return null;
        }
        if(nextProps.style != prevState.style || nextProps.type != prevState.type){
            return {style:nextProps.style,type:nextProps.type}
        }else{
            return null
        }
    }
    
    render(){
            let mainPhoto = this.props.pageData.loggedInUserDetails.avtar

            if (mainPhoto) {
                const splitVal = mainPhoto.split('/')
                if (splitVal[0] == "http:" || splitVal[0] == "https:") {
                } else {
                    mainPhoto = this.props.pageData.imageSuffix + mainPhoto
                }
            }

            return (
                    <li className={!this.props.mobileMenu ? `nav-item dropdown user-setting-menu-head${this.state.style == "block" ? " active" : ""}` : `dropdown MobDropdownNav${this.state.style == "block" ? " active" : ""}`}  style={{cursor:"pointer"}}  >
                        <a className={!this.props.mobileMenu ? "parent nav-link notclose usepicHead" : "parent loggedUer notclose usepicHead"} onClick={(e) => this.props.openToggle("settings",e)}  style={{cursor:"pointer"}} title={this.props.pageData.loggedInUserDetails.displayname} href="#" 
                            role="button">
                            <img className="userPic notclose parent" src={mainPhoto} />
                            {
                            !this.props.mobileMenu ?
                            this.props.pageData.loggedInUserDetails ? 
                                <span className="user_title notclose parent">{this.props.pageData.loggedInUserDetails.first_name}</span>
                                : null
                            : null
                            }
                            {
                                this.props.mobileMenu ? 
                                    <span className="title usertitle parent">{this.props.t("Settings")}</span>
                                : null
                            }
                        </a>
                        {
                        !this.props.mobileMenu ? 
                        <ul className="dropdown-menu dropdown-menu-right iconMenuList" ref={this.props.setSettingsWrapperRef}  style={{display:this.state.style}} >
                            <span className="dropdown-menu-arrow"></span>
                            <Items {...this.props} />
                        </ul>
                        : null
                        }
                    </li>
            )
    }
}


export default SettingMenus;