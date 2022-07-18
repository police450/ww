import React from 'react'
import { connect } from 'react-redux';
import Router from 'next/router';
import Head from "next/head"
import dynamic from 'next/dynamic'
import { I18nextProvider } from 'react-i18next';
import NProgress from 'nprogress'
import App from 'next/app'
import {i18n} from "../i18n"
import * as actions from '../store/actions/general';
import {wrapper} from "../store/index";
import config from "../config";
import socketOpen from "socket.io-client";
import SendMessageToApps from "../components/SendMessageToApps/Index"
import Header from "../containers/Header/Index"
import Footer from "../containers/Footer/Index"
import AdsIndex from "../containers/Ads/Index"
import WithErrorHandler from "../hoc/withErrorHandler/withErrorHandler"
import Gdpr from "../containers/Gdpr/Index"
import UnsupportedBrowser from "../containers/UnsupportedBrowser/Index"
import SideFixedMenu from "../containers/Menu/SideFixedMenu"

const MiniPlayer = dynamic(() => import("../containers/Video/MiniPlayer"), {
    ssr: false,
});
const AudioPlayer = dynamic(() => import("../containers/Audio/Player"), {
    ssr: false,
});
const ChatMessages = dynamic(() => import("../containers/Messages/Chat"), {
    ssr: false,
});
const socket = socketOpen(config.actualPath,{path:`${config.basePath}socket.io`});

class MyApp extends App {
	constructor(props){
		super(props)
		this.state = {
			chats:[],
			width:props.pageData && props.pageData.fromAPP ? 990 : 993,
			levelPermissions:{},
			appSettings:{}
		}
		this.updateWindowDimensions = this.updateWindowDimensions.bind(this)
		this.closeMenu = this.closeMenu.bind(this)
	}
    static getInitialProps = wrapper.getInitialAppProps(store => async ({Component, ctx}) => {
		// Recompile pre-existing pageProps
		let pageProps = {};
		ctx.store = store
		if (Component.getInitialProps)
			pageProps = await Component.getInitialProps(ctx);
		// Initiate vars to return
		const { req } = ctx;
		let initialI18nStore = {};
		let initialLanguage = null;
		let currentPageUrl = null
		// Load translations to serialize if we're serverside
		if(req){
			currentPageUrl = req.originalUrl
		}
		if (req && req.i18n) {
			[initialLanguage] = req.i18n.languages;
			i18n.language = initialLanguage;			
			initialI18nStore = req.i18n.store.data;
		} else {
			// Load newly-required translations if changing route clientside
			// await Promise.all(
			// 	i18n.nsFromReactTree
			// 		.filter(ns => !i18n.hasResourceBundle(i18n.languages[0], ns))
			// 		.map(ns => new Promise(resolve => i18n.loadNamespaces(ns, () => resolve())))
			// );
			initialI18nStore = i18n.store.data;
			initialLanguage = i18n.language;
		}
		let userAgent;
		if (req) { // if you are on the server and you get a 'req' property from your context
			userAgent = req.headers['user-agent'] // get the user-agent from the headers
		} else {
			userAgent = navigator.userAgent // if you are on the client you can access the navigator from the window object
		}

		let isMobile = false 
		if(userAgent){
			isMobile = Boolean(userAgent.match(
				/Android|BlackBerry|iPhone|iPad|iPod|Opera Mini|IEMobile|WPDesktop/i
		  	))
		}

		// `pageProps` will get serialized automatically by NextJs
		return {
			pageProps: {
				...pageProps,
				isMobile:isMobile,
				initialI18nStore,
				initialLanguage,
				currentPageUrl:currentPageUrl
			},
		};
	})
	onRouteChangeStart = () => {
		if(!this.props.menuOpen && this.state.width > 992)
			this.props.setMenuOpen(true)
		NProgress.start()
	};
	onRouteChangeComplete = () => {
		NProgress.done()
		$("body").removeClass("modal-open");
		$("body").css("overflow",'auto');
	};
	onRouteChangeError = () => {
		NProgress.done()
	};
	closeChat = (message_id) => {
		let chats = [...this.state.chats]
		let index = this.getItemIndex(message_id)
		if(index > -1){
			chats.splice(index, 1);
			this.setState({localUpdate:true,chats:chats});
		}
	}
	minimizeChat = (message_id) => {
		let chats = [...this.state.chats]
		let index = this.getItemIndex(message_id)
		if(index > -1){
			if(!chats[index].minimize || chats[index].minimize == 0)
				chats[index].minimize = 1;
			else
				chats[index].minimize = 0
			this.setState({localUpdate:true,chats:chats});
		}
	}
	updateWindowDimensions() {
        let width = window.innerWidth
		let chats = [...this.state.chats];
		if(chats.length > 0){
			if(width < 700){
				if (chats.length > 2){
					chats.shift()
					chats.shift()
				}else if (chats.length > 1){
					chats.shift()
				}
			}else if(width < 1060){
				if (chats.length > 2){
					chats.shift()
				}
			}
		}
		this.setState({"width": window.innerWidth,chats:chats});
    }
	componentDidUpdate(prevProps,_prevState) {
		if(typeof window != "undefined" && prevProps.pageProps && this.props.pageProps && this.props.pageProps.pageData && prevProps.pageProps.pageData && prevProps.pageProps.pageData.loggedInUserDetails != this.props.pageProps.pageData.loggedInUserDetails && this.props.pageProps.pageData.loggedInUserDetails){
			SendMessageToApps({props:this.props.pageProps,type:"loggedinUser"});
		}
	}
	componentDidMount() {

		const { BroadcastChannel } = require('broadcast-channel');
        const userChannel = new BroadcastChannel('user');
        if (this.props.pageProps.pageData && this.props.pageProps.pageData.logout) {
            userChannel.postMessage({
                payload: {
                    type: "LOGOUT"
                }
            });
        } 
        userChannel.onmessage = data => {
            if (data.payload.type === "LOGIN") {
                if (!this.props.pageProps.pageData.loggedInUserDetails || this.props.pageProps.pageData.loggedInUserDetails.user_id != this.props.pageProps.pageData.loggedInUserDetails.user_id) {
                    if(this.props.pageProps.pageData.loggedInUserDetails)
                        socket.emit('chatJoin', {id:this.props.pageProps.pageData.loggedInUserDetails.user_id})
                    let path = this.state.previousUrl ? this.state.previousUrl : Router.asPath
                    if(path == "/login" || path == "/signup"){
                        Router.push('/');
                    }else if(this.props.pageProps.customURLparams){
                        Router.push(this.props.pageProps.customPageURLparams+"?"+this.props.customURLparams,path);
                    }else{
                        Router.push(path).catch((err) => {
							window.location.href = path;
						})
                    }
					
                }
            } else if (data.payload.type == "LOGOUT") {
                if (this.props.pageProps.pageData.loggedInUserDetails) {
                    socket.emit('chatLeave', {id:this.props.pageProps.pageData.loggedInUserDetails.user_id})
                    Router.push("/")
                    this.props.updatePlayerData([], [])
                    this.props.updateAudioData([], 0)
					SendMessageToApps({props:this.props.pageProps,type:"loggedOut"});
                }
            }
        }

		// if(this.props.pageProps.pageData.loggedInUserDetails){
			SendMessageToApps({props:this.props.pageProps,type:"loggedinUser",theme:this.props.pageProps.pageData.themeMode});
		// }

		window.addEventListener('resize', this.updateWindowDimensions);
		this.updateWindowDimensions();
		Router.events.on("routeChangeStart", this.onRouteChangeStart);
		Router.events.on("routeChangeComplete", this.onRouteChangeComplete);
		Router.events.on("routeChangeError", this.onRouteChangeError);
		//open chats
		socket.on('chatOpen', data => {
			let chats = [...this.state.chats]
			let index = this.getItemIndex(data.message_id)
			if(index > -1){
				return
			}
			if(this.state.width < 700){
				chats.shift();
			}else if(this.state.width < 1060){
				if(chats.length == 2){
					chats.shift();
				}
			}else{
				if(chats.length == 3){
					chats.shift();
				}
			}
			chats.push(data)
			this.setState({localUpdate:true,chats:chats})
		})
		socket.on('chatMessageCreate', data => {
			let chat = data.chat
			let chats = [...this.state.chats]
			let index = this.getItemIndex(chat.message_id)
			if(index > -1){
				return
			}
			if(this.state.width < 700){
				chats.shift();
			}else if(this.state.width < 1060){
				if(chats.length == 2){
					chats.shift();
				}
			}else{
				if(chats.length == 3){
					chats.shift();
				}
			}
			chats.push(chat)
			this.setState({localUpdate:true,chats:chats})
		})
		socket.on('chatDelete', data => {
            let id = data.message_id
            const itemIndex = this.getItemIndex(id)
            if (itemIndex > -1) {
                const messages = [...this.state.chats]
                messages.splice(itemIndex, 1);
                this.setState({localUpdate:true, chats: messages})
            }
        })

	}
	
	getItemIndex(item_id) {
        const chats = [...this.state.chats];
        const itemIndex = chats.findIndex(p => p["message_id"] == item_id);
        return itemIndex;
    }
	static getDerivedStateFromProps(nextProps, prevState){
		if (prevState.localUpdate){
            return {...prevState,localUpdate:false}
        }else if(nextProps.pageProps && nextProps.pageProps.pageData && nextProps.pageProps.pageData.appSettings && (JSON.stringify(nextProps.pageProps.pageData.appSettings) != JSON.stringify(prevState.appSettings) || JSON.stringify(nextProps.pageProps.pageData.levelPermissions) != JSON.stringify(prevState.levelPermissions) )){
			return {
				...prevState,
				levelPermissions:nextProps.pageProps.pageData.levelPermissions,
				appSettings:nextProps.pageProps.pageData.appSettings,
			}
		}else if(nextProps.pageProps && nextProps.pageProps.pageData && nextProps.pageProps.pageData.levelPermissions && (JSON.stringify(nextProps.pageProps.pageData.levelPermissions) != JSON.stringify(prevState.levelPermissions) )){
			return {
				...prevState,
				levelPermissions:nextProps.pageProps.pageData.levelPermissions
			}
		}
		
		return null;
	}
	closeMenu = () => {
        this.props.setMenuOpen(true)
    }
	render() {
		const { Component, pageProps } = this.props
		let { initialLanguage, initialI18nStore,isMobile } = pageProps;
		
		if(!pageProps.pageData){
			return null;
		}
		if(pageProps.pageData.fromAPP){
			isMobile = true;
		}
		if(!pageProps.pageData.appSettings){
			pageProps.pageData.appSettings = this.state.appSettings
			pageProps.pageData.levelPermissions = this.state.levelPermissions
		}
		
		i18n.store.data = initialI18nStore
		if(!i18n.language){
			i18n.language = initialLanguage
			i18n.translator.changeLanguage(initialLanguage);
		}
		let pathname = true
		if(typeof window != "undefined"){
			if(Router.pathname == "/messanger"){
				pathname = false
			}
		}


		let isIE = this.state.IEBrowser
		let fixedHeader = ""
        let disableMarginLeftClass = ""
        if (pageProps.pageData.appSettings["fixed_header"] == 1 && this.state.width > 992) {
            if (!pageProps.pageData.removeFixedMenu)
                fixedHeader = " fixed-header"
            else
                fixedHeader = " fixed-header nofixed-header"
            if (pageProps.hideSmallMenu || pageProps.pageData.hideSmallMenu) {
                disableMarginLeftClass = " marginLeft0"
            }
        }
        if (pageProps.pageData.appSettings["fixed_header"] == 0 && this.state.width > 992) {
            fixedHeader = " fixed-layout"
        }
		let fixedMenu = ""
        if (this.state.width > 992)
            fixedMenu = (pageProps.hideSmallMenu || pageProps.pageData.hideSmallMenu ? " top-menu" : " sidemenu") + disableMarginLeftClass + (this.props.menuOpen ? "" : " sidemenu-opened")
        
		const generalInfo = pageProps.pageData.pageInfo ? pageProps.pageData.pageInfo : {}
		
		if(pageProps.i18n)
			pageProps.t = pageProps.i18n.t
		else{
			pageProps.i18n = i18n
			pageProps.t = i18n.t
		}
				
		return (
			<React.Fragment>
				<I18nextProvider
					i18n={i18n}
					initialLanguage={initialLanguage}
					initialI18nStore={initialI18nStore}
				>
					<Head>
						<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=0"></meta>
					</Head>
					<React.Fragment>
						{
							isIE ?
								<UnsupportedBrowser {...pageProps} />
							: null
						}
						{
							pageProps.embedVideo ?
								pageProps.children
							: null
						}
						{
							!pageProps.maintenance && !isIE && !pageProps.pageData.maintanance && !pageProps.embedVideo ?
								<React.Fragment>
									<Header {...pageProps} languageChanged={this.props.languageChanged} menuOpen={this.props.menuOpen} layout={this.state.width > 992 ? "" : "mobile"} layoutWidth={this.state.width} socket={socket} />
								</React.Fragment>
								: null
						} 
						{
							!isIE && !pageProps.embedVideo ?
								!pageProps.liveStreaming ?
									<WithErrorHandler {...pageProps}>
										<div className={`main-content${pageProps.pageData.themeType == 2 ? " adv-theme" : ""}${fixedMenu}${pageProps.pageData.loggedInUserDetails ? " user-logged-in" + fixedHeader : fixedHeader}${this.state.width > 992 ? "" : " mobile-layout-cnt"}${pageProps.pageData.slideshow || (pageProps.pageData.videos && pageProps.pageData.videos.featured) ? " slideshow-enable" : ""}${pageProps.pageData.showHomeButtom == 1 || pageProps.pageData.userProfilePage == 1 ? " user-subscription-page" : ""}${` ${(generalInfo.type ? generalInfo.type : "no-data").replace(/_/g, '-')}-cs-page`}`}>
											<div id="theme-selector">
												<div className="theme-toggle">
													<span className="material-icons">brush</span> 
													</div>
												<div id="theme-selector-container">
													<div className="theme-selector-wrapper">
														<div className="d-grid py-5 px-4">
															<a href="https://codecanyon.net/item/playtubevideo-the-perfect-online-react-video-cms-and-video-sharing-platform/26509780" target="_blank" className="btn btn-primary btn-block">Buy PlayTubeVideo Now!</a>
														</div>
														<div className="p-2 text-center color-dark">
															<h6>{pageProps.t("GET AN AWESOME START!")}</h6>
															<p className="sub-heading-theme">{pageProps.t("With easy ONE CLICK INSTALL and fully customizable options, our demos the best start you'll ever get!")}</p>
															<p>{pageProps.t("PlayTubeVideo comes with two beautiful themes, choose theme from below.")}</p>
														</div>
														<div className="themeBtn mx-4">
															{
																pageProps.pageData.themeType == 1 ?
																	<a className="btn btn-secondary btn-sm active" href="#" onClick={(e) => e.preventDefault()}>Default</a>
																	:
																	<a className="btn btn-secondary btn-sm" href="?theme=default">Default</a>
															}
															{
																pageProps.pageData.themeType == 2 ?
																	<a className="btn btn-secondary btn-sm active" href="#" onClick={(e) => e.preventDefault()}>Trendott</a>
																	:
																	<a className="btn btn-secondary btn-sm" href="?theme=trendott">Trendott</a>
															}

														</div>
													</div>
												</div>
											</div>
											{
												this.state.width > 992 ?
													<React.Fragment>
														<div className="sidemenu-overlay" onClick={this.closeMenu}></div>
														<SideFixedMenu {...pageProps}  languageChanged={this.props.languageChanged} menuOpen={this.props.menuOpen} socket={socket} />
													</React.Fragment>
													: null
											}
											<div className={`content-wrap${this.props.menuOpen && !pageProps.hideSmallMenu && this.state.width > 992 ? " ml100" : this.props.menuOpen && pageProps.hideSmallMenu && this.state.width > 992 ? " ml0" : ""}${this.state.width > 992 ? "" : " mobile-layout"}${pageProps.pageData.showHomeButtom == 1 || pageProps.pageData.userProfilePage ? " user-subscription-cnt" : ""}`}>
												{
													pageProps.pageData.appSettings['below_header'] ?
														<AdsIndex className={`${pageProps.pageData.hideSmallMenu ? "nopad-ads " : ""}header_advertisement`} paddingTop="90px" ads={pageProps.pageData.appSettings['below_header']} />
														: null
												}
												<Component {...pageProps} appViewWidth={this.state.width} isMobile={isMobile ? 992 : 993} socket={socket} />
											</div>
										</div>
									</WithErrorHandler>
									:
									<WithErrorHandler {...pageProps}>
										<div className={`ls_contentWrap${this.state.width > 992 ? "" : " mobile-layout-cnt"}`}>
											<div className="ls_mainContent">
												<Component {...pageProps} appViewWidth={this.state.width} isMobile={isMobile ? 992 : 993} socket={socket} />
											</div>
										</div>
									</WithErrorHandler>
								: null
						}
					</React.Fragment>


					<MiniPlayer {...pageProps} appViewWidth={this.state.width}  languageChanged={this.props.languageChanged} isMobile={isMobile ? 992 : 993} socket={socket} />
					<AudioPlayer {...pageProps} appViewWidth={this.state.width}  languageChanged={this.props.languageChanged} isMobile={isMobile ? 992 : 993} socket={socket} />
					{
						this.state.chats.length > 0 && pathname ?
						<div className="chat-containers">
						{
							this.state.chats.map((chat,index) => {
								return (
									<ChatMessages appViewWidth={this.state.width}  languageChanged={this.props.languageChanged} fromSmallChat={true} chatIndex={index} minimize={chat.minimize} minimizeChat={this.minimizeChat} closeChat={this.closeChat} key={chat.message_id} {...pageProps} {...this.state.t} socket={socket} id={chat.message_id} message={chat} chats={[]} />
								)
							})
						}
						</div>
						: null
					}
					{
						!pageProps.maintenance && !pageProps.embedVideo && !isIE && !pageProps.pageData.maintanance && !pageProps.liveStreaming ?
							<React.Fragment>
								{
									pageProps.pageData.appSettings['above_footer'] ?
										<AdsIndex className="footer_advertisement" paddingTop="20px" ads={pageProps.pageData.appSettings['above_footer']} />
										: null
								}
								<Footer {...pageProps}  languageChanged={this.props.languageChanged} layout={this.state.width > 992 ? "" : "mobile"} socket={socket} />
								{
									!pageProps.pageData.fromAPP ? 
									<Gdpr {...pageProps}  languageChanged={this.props.languageChanged} layout={this.state.width > 992 ? "" : "mobile"} socket={socket} />
									: null
								}
							</React.Fragment>
						: null
					}
				</I18nextProvider>
			</React.Fragment>
		)
	}
}


const mapStateToProps = state => {
    return {
        menuOpen: state.search.menuOpen,
        languageChanged: state.search.languageChanged,

    };
};

const mapDispatchToProps = dispatch => {
    return {
        setMenuOpen: (status) => dispatch(actions.setMenuOpen(status)),
		updatePlayerData: (relatedVideos, playlistVideos, currentVideo, deleteMessage, deleteTitle) => dispatch(actions.updatePlayerData(relatedVideos, playlistVideos, currentVideo, deleteMessage, deleteTitle)),
        updateAudioData: (audios, song_id) => dispatch(actions.updateAudioData(audios, song_id))
    };
};

export default wrapper.withRedux(connect(mapStateToProps,mapDispatchToProps)(MyApp))
