import React from "react"
import Menu from "../Menu/Index"
import FixedMenu from "../Menu/Fixed"
import Link from "../../components/Link"
 

class Index extends React.Component{
    constructor(props){
            super(props)
            
    }
    render (){
        let logo = ""
        if (this.props.pageData.themeMode == "dark") {
            logo = this.props.pageData['imageSuffix'] + this.props.pageData.appSettings['darktheme_logo']
        } else {
            logo = this.props.pageData['imageSuffix'] + this.props.pageData.appSettings['lightheme_logo']
        }

        return (
            this.props.liveStreaming ? 
                <div className="ls_HeaderWrap">
                    <div className="container-fluid">
                        <div className="ls_headerContent">
                            <div className="logo">
                                <Link href="/">
                                    <a>
                                        <img src={logo} />
                                    </a>
                                </Link>
                            </div>
                        </div>
                    </div>
                </div>
            :
            this.props.layout !="mobile" ?
                this.props.pageData.appSettings["fixed_header"] == 1 ?
                    <FixedMenu {...this.props} />
                :
                    <Menu {...this.props} />
            :
                <Menu {...this.props} mobileMenu={true} />
        )
    }
}
export default Index