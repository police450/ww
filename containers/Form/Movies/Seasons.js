import React, { Component } from "react"
import { connect } from 'react-redux';
import * as actions from '../../../store/actions/general';
import axios from "../../../axios-orders"
import Translate from "../../../components/Translate/Index";
import dynamic from 'next/dynamic'
import swal from "sweetalert"
import AddEpisode from "./AddEpisode"
import AddCast from "./AddCast"
import Image from "../../Image/Index"
import AddImage from "./AddImage"

class Seasons extends Component {
    constructor(props) {
        super(props)
        this.state = {
            seasons:props.seasonsCrew ? props.seasonsCrew : props.seasons,
            movie:props.movie,
            selected:props.selected ? props.selected : 0,
            selectedTabs:props.selectedTabs ? props.selectedTabs : [],
            fromCastnCrew:props.fromCastnCrew ? props.fromCastnCrew : false
        }
        this.addEpisode = this.addEpisode.bind(this)
        this.addCast = this.addCast.bind(this)
        this.addCrew = this.addCrew.bind(this)
        this.editCast = this.editCast.bind(this)
        this.deleteCast = this.deleteCast.bind(this)
        this.editCrew = this.editCrew.bind(this)
        this.deleteCrew = this.deleteCrew.bind(this)
        this.editEpisode = this.editEpisode.bind(this)
        this.deleteEpisode = this.deleteEpisode.bind(this)
        this.deleteSeason = this.deleteSeason.bind(this)

    }
    static getDerivedStateFromProps(nextProps, prevState) {
        if(typeof window == "undefined" || nextProps.i18n.language != $("html").attr("lang")){
            return null;
        }
        if(prevState.localUpdate){
            return {...prevState,localUpdate:false}
        }else {
            return {
                movie:nextProps.movie ? nextProps.movie : {},
                seasons:nextProps.seasonsCrew ? nextProps.seasonsCrew : nextProps.seasons ? nextProps.seasons : [],  
                fromCastnCrew:nextProps.fromCastnCrew ? nextProps.fromCastnCrew : false,
                //selectedTabs:nextProps.selectedTabs ? nextProps.selectedTabs : [],      
            }
        }
    }
    updateValues = (values) => {
        //update the values
        if(this.state.fromCastnCrew){
            this.props.updateSteps({key:"castncrew",value:[...values[0].castncrew]})
            return
        }
        this.props.updateSteps({key:"seasons",value:values})
    }
    createSeason = () => {
        if(this.state.createSeason){
            return;
        }
        this.setState({createSeason:true,localUpdate:true})
        //send request to create season
        let formData = new FormData();
        
        formData.append('movie_id', this.state.movie.movie_id)
         

        const config = {
            headers: {
                'Content-Type': 'multipart/form-data',
            }
        };
        let url = '/movies/create-season';
        
        axios.post(url, formData, config)
            .then(response => {
                if (response.data.error) {
                    this.setState({localUpdate:true, error: response.data.error, createSeason: false });
                } else {
                    this.setState({createSeason:false,localUpdate:true,seasons:[...this.state.seasons , response.data ]},() => {
                        this.updateValues(this.state.seasons)
                    })
                }
            }).catch(err => {
                this.setState({localUpdate:true, createSeason: false, error: err });
            });
        

    }
    selectedtab = (selected,id) => {
        let selectedTabs = !this.state.selectedTabs ? [] : this.state.selectedTabs
        selectedTabs[id] = selected
        this.setState({selectedTabs:selectedTabs,localUpdate:true});
    }
    deleteEpisode = (id,e) => {
        e.preventDefault();
        swal({
            title: Translate(this.props,"Delete Episode"),
            text: Translate(this.props,"Are you sure you want to delete this episode?"),
            icon: "warning",
            buttons: true,
            dangerMode: true,
        })
            .then((willDelete) => {
                if (willDelete) {
                    const formData = new FormData()
                    formData.append('id', id)
                    formData.append('movie_id', this.state.movie.movie_id);
                    const url = "/movies/season/episode/delete"
                    axios.post(url, formData)
                        .then(response => {
                            if (response.data.error) {
                                swal("Error", Translate(this.props,"Something went wrong, please try again later", "error"));
                            } else {
                                let message = response.data.message
                                this.props.openToast(Translate(this.props,message), "success");
                                let season_id = response.data.season_id
                                const items = [...this.state.seasons]
                                const itemIndex = items.findIndex(p => p["season_id"] == season_id)
                                if(itemIndex > -1){
                                    let casts = items[itemIndex]
                                    const episode = casts.episodes
                                    const itemIndexEpisode = episode.findIndex(p => p["episode_id"] == id)
                                    if(itemIndexEpisode > -1){
                                        episode.splice(itemIndexEpisode, 1)
                                        this.updateValues(items)
                                    }
                                }
                            }
                        }).catch(err => {
                            swal("Error", Translate(this.props,"Something went wrong, please try again later"), "error");
                        });
                    //delete
                } else {

                }
            });
    }
    editEpisode = (id,season_id,e) => {
        e.preventDefault();
        const items = [...this.state.seasons]
        const itemIndex = items.findIndex(p => p["season_id"] == season_id)
        if(itemIndex > -1){
            let season = items[itemIndex];
            let episodes = season.episodes
            const episodIndex = episodes.findIndex(p => p["episode_id"] == id);
            if(episodIndex > -1){
                this.setState({addEpisode:true,addPostSeason:season_id,editEpisodeItem:episodes[episodIndex],localUpdate:true})
            }
        }
    }
    addEpisode = (season_id,e) => {
        e.preventDefault();
        this.setState({addEpisode:true,addPostSeason:season_id,localUpdate:true})
    }
    addCrew = (season_id,e) => {
        e.preventDefault();
        this.setState({addCast:true,addPostSeason:season_id,isCrew:true,localUpdate:true})
    }
    addCast = (season_id,e) => {
        e.preventDefault();
        this.setState({addCast:true,addPostSeason:season_id,localUpdate:true,localUpdate:true})
    }
    editCrew = (id,season_id,e) => {
        e.preventDefault();
        this.editCast(id,season_id,e,true);
    } 
    deleteCast = (id,e) => {
        e.preventDefault();
        swal({
            title: Translate(this.props,"Delete Cast"),
            text: Translate(this.props,"Are you sure you want to delete this cast?"),
            icon: "warning",
            buttons: true,
            dangerMode: true,
        })
            .then((willDelete) => {
                if (willDelete) {
                    const formData = new FormData()
                    formData.append('id', id)
                    formData.append('movie_id', this.state.movie.movie_id);
                    const url = "/movies/season/cast/delete"
                    axios.post(url, formData)
                        .then(response => {
                            if (response.data.error) {
                                swal("Error", Translate(this.props,"Something went wrong, please try again later", "error"));
                            } else {
                                let message = response.data.message
                                this.props.openToast(Translate(this.props,message), "success");
                                let season_id = !this.state.fromCastnCrew ? response.data.season_id : 0
                                const items = [...this.state.seasons]
                                const itemIndex = items.findIndex(p => p["season_id"] == season_id)
                                if(itemIndex > -1){
                                    let casts = items[itemIndex]
                                    const castncrew = casts.castncrew
                                    const itemIndexCast = castncrew.findIndex(p => p["cast_crew_id"] == id)
                                    if(itemIndexCast > -1){
                                        castncrew.splice(itemIndexCast, 1)
                                        this.updateValues(items)
                                    }
                                }
                            }
                        }).catch(err => {
                            swal("Error", Translate(this.props,"Something went wrong, please try again later"), "error");
                        });
                    //delete
                } else {

                }
            }); 
    }
    deleteCrew = (id,e) => {
        e.preventDefault();
        swal({
            title: Translate(this.props,"Delete Crew"),
            text: Translate(this.props,"Are you sure you want to delete this crew?"),
            icon: "warning",
            buttons: true,
            dangerMode: true,
        })
            .then((willDelete) => {
                if (willDelete) {
                    const formData = new FormData()
                    formData.append('id', id)
                    formData.append('movie_id', this.state.movie.movie_id);
                    const url = "/movies/season/crew/delete"
                    axios.post(url, formData)
                        .then(response => {
                            if (response.data.error) {
                                swal("Error", Translate(this.props,"Something went wrong, please try again later", "error"));
                            } else {
                                let message = response.data.message
                                this.props.openToast(Translate(this.props,message), "success");
                                let season_id = !this.state.fromCastnCrew ? response.data.season_id : 0
                                const items = [...this.state.seasons]
                                const itemIndex = items.findIndex(p => p["season_id"] == season_id)
                                if(itemIndex > -1){
                                    let casts = items[itemIndex]
                                    const castncrew = casts.castncrew
                                    const itemIndexCast = castncrew.findIndex(p => p["cast_crew_id"] == id)
                                    if(itemIndexCast > -1){
                                        castncrew.splice(itemIndexCast, 1)
                                        this.updateValues(items)
                                    }
                                }
                            }
                        }).catch(err => {
                            swal("Error", Translate(this.props,"Something went wrong, please try again later"), "error");
                        });
                    //delete
                } else {

                }
            });
    }
    deleteSeason = (season_id,e) => {
        e.preventDefault();
        swal({
            title: Translate(this.props,"Delete Season?"),
            text: Translate(this.props,"This will also delete all episodes attached to this season."),
            icon: "warning",
            buttons: true,
            dangerMode: true,
        })
            .then((willDelete) => {
                if (willDelete) {
                    const formData = new FormData()
                    formData.append('id', season_id)
                    formData.append('movie_id', this.state.movie.movie_id);
                    const url = "/movies/season/delete"
                    axios.post(url, formData)
                        .then(response => {
                            if (response.data.error) {
                                swal("Error", Translate(this.props,"Something went wrong, please try again later", "error"));
                            } else {
                                let message = response.data.message
                                this.props.openToast(Translate(this.props,message), "success");
                                const items = [...this.state.seasons]
                                const itemIndex = items.findIndex(p => p["season_id"] == season_id)
                                if(itemIndex > -1){
                                    items.splice(itemIndex, 1)
                                    this.updateValues(items)
                                }
                            }
                        }).catch(err => {
                            swal("Error", Translate(this.props,"Something went wrong, please try again later"), "error");
                        });
                    //delete
                } else {

                }
            });
    }
    closeEpisodeCreate = (data,message) => {
        if(message && data){
            this.props.openToast(Translate(this.props,message), "success");
        }
        if(data && typeof data.episode_id != "undefined"){
            const items = [...this.state.seasons]
            const itemIndex = items.findIndex(p => p["season_id"] == this.state.addPostSeason)
            if(itemIndex > -1){
                let season = items[itemIndex];
                let episodes = season.episodes
                if(this.state.editEpisodeItem){
                    const episodIndex = episodes.findIndex(p => p["episode_id"] == this.state.editEpisodeItem.episode_id);
                    if(episodIndex > -1){
                        episodes[episodIndex] = data
                        this.setState({addEpisode:false,addPostSeason:0,editEpisodeItem:null,localUpdate:true},() => {
                            this.updateValues(items)
                        })
                        
                    }
                }else{
                    episodes.push(data)
                    this.setState({addEpisode:false,addPostSeason:0,editEpisodeItem:null,localUpdate:true},() => {
                        this.updateValues(items)
                    })
                }
            }
        }else{
            this.setState({addEpisode:false,addPostSeason:0,editEpisodeItem:null,localUpdate:true})
        }
        
    }
    editCast = (id,season_id,e,isCrew = false) => {
        e.preventDefault();
        const items = [...this.state.seasons]
        const itemIndex = items.findIndex(p => p["season_id"] == season_id)
        if(itemIndex > -1){
            let season = items[itemIndex];
            let casts = season.castncrew
            const castIndex = casts.findIndex(p => p["cast_crew_id"] == id);
            if(castIndex > -1){
                this.setState({addCast:true,addPostSeason:season_id,editCastItem:casts[castIndex],isCrew:isCrew,localUpdate:true})
            }
        }
    }
    closeAddImageCreate = (data,message) => {
        if(message && data){
            this.props.openToast(Translate(this.props,message), "success");
        }
        if(data && typeof data.image != "undefined"){
            const items = [...this.state.seasons]
            const itemIndex = items.findIndex(p => p["season_id"] == this.state.season_id_image)
            if(itemIndex > -1){
                items[itemIndex]['image'] = data.image
                this.setState({addSeasonImage:false,season_id_image:0,isEditImage:false,localUpdate:true},() => {
                    this.updateValues(items)
                })
            }
        }else{
            this.setState({addSeasonImage:false,season_id_image:0,isEditImage:false,localUpdate:true})
        }
    }
    closeCastCreate = (data,message) => {
        if(message && data){
            this.props.openToast(Translate(this.props,message), "success");
        }
        if(data && typeof data.cast_crew_id != "undefined"){
            const items = [...this.state.seasons]
            const itemIndex = items.findIndex(p => p["season_id"] == this.state.addPostSeason)
            if(itemIndex > -1){
                let season = items[itemIndex];
                let casts = season.castncrew
                if(this.state.editCastItem){
                    const castIndex = casts.findIndex(p => p["cast_crew_id"] == this.state.editCastItem.cast_crew_id);
                    if(castIndex > -1){
                        casts[castIndex] = data
                        this.setState({addCast:false,addPostSeason:0,editCastItem:null,isCrew:null,localUpdate:true},() => {
                            this.updateValues(items)
                        })
                        
                    }
                }else{
                    casts.push(data)
                    this.setState({addCast:false,addPostSeason:0,editCastItem:null,isCrew:null,localUpdate:true},() => {
                        this.updateValues(items)
                    })
                }
            }
        }else{
            this.setState({addCast:false,addPostSeason:0,editCastItem:null,localUpdate:true})
        }
    }
    render(){
        let addEpisode = null

        if(this.state.addEpisode){

            addEpisode = (
                <div className="popup_wrapper_cnt">
                    <div className="popup_cnt">
                        <div className="comments">
                            <div className="VideoDetails-commentWrap">
                                <div className="popup_wrapper_cnt_header">
                                    <h2>{this.state.editEpisodeItem ? Translate(this.props,"Edit Episode") : Translate(this.props,"Create Episode")}</h2>
                                    <a onClick={this.closeEpisodeCreate}  className="_close"><i></i></a>
                                </div>
                                <AddEpisode fromCastnCrew={this.state.fromCastnCrew} {...this.props} closeEpisodeCreate={this.closeEpisodeCreate} editItem={this.state.editEpisodeItem} movie={this.state.movie} season_id={this.state.addPostSeason} />
                            </div>
                        </div>
                    </div>
                </div>
            )
        }

        let addCast = null
        if(this.state.addCast){

            addCast = (
                <div className="popup_wrapper_cnt">
                    <div className="popup_cnt">
                        <div className="comments">
                            <div className="VideoDetails-commentWrap">
                                <div className="popup_wrapper_cnt_header">
                                    <h2>{this.state.editCastItem ? Translate(this.props,this.state.isCrew ? "Edit Crew" : "Edit Cast") : Translate(this.props, this.state.isCrew ? "Create Crew" : "Create Cast" )}</h2>
                                    <a onClick={this.closeCastCreate}  className="_close"><i></i></a>
                                </div>
                                <AddCast {...this.props} fromCastnCrew={this.state.fromCastnCrew} resource_type={!this.state.fromCastnCrew ? "season" : "movie"} isCrew={this.state.isCrew} resource_id={this.state.fromCastnCrew ? this.state.movie.movie_id : this.state.addPostSeason} closeCastCreate={this.closeCastCreate} editItem={this.state.editCastItem} movie={this.state.movie} season_id={this.state.addPostSeason} />
                            </div>
                        </div>
                    </div>
                </div>
            )
        }
        let addImage = null
        if(this.state.addSeasonImage){
            addImage = (
                <div className="popup_wrapper_cnt">
                    <div className="popup_cnt">
                        <div className="comments">
                            <div className="VideoDetails-commentWrap">
                                <div className="popup_wrapper_cnt_header">
                                    <h2>{Translate(this.props,this.state.isEditImage ? "Edit Image" : "Add Image")}</h2>
                                    <a onClick={() => {
                                        this.setState({localUpdate:true,addSeasonImage:false})
                                    }}  className="_close"><i></i></a>
                                </div>
                                <AddImage {...this.props} closeAddImageCreate={this.closeAddImageCreate} image={this.state.seasons[this.state.season_id_selected].image} season_id={this.state.season_id_image} />
                            </div>
                        </div>
                    </div>
                </div>
            )
        }
        return (
            <React.Fragment>
                {
                    addImage
                }
                {
                    addEpisode
                }
                {
                    addCast
                }
            
                <div className="accordion" id="seasonData">
                    {
                        !this.state.fromCastnCrew ? 
                    <button className="add_season" onClick={this.createSeason}>                        
                        {
                            this.props.t(!this.state.createSeason ? "Add Season" : "Creating Season...")
                        }
                    </button>
                    : null
                    }
                    {
                        this.state.seasons.map((season,index) => {
                            return (
                                <div className="card mb-3" key={season.season_id+"season"}>
                                    {
                                        !this.state.fromCastnCrew ? 
                                    <div className="card-header" id={`heading${season.season_id}`}>
                                        <h5 className="mb-0 d-flex align-items-center justify-content-between">
                                            <button className="btn btn-secondary btn-sm d-flex align-items-center" onClick={() => {this.selectedtab("episode")}} type="button" data-bs-toggle="collapse" data-bs-target={`#collapse${season.season_id}`} aria-expanded="true" aria-controls={`collapse${season.season_id}`}>
                                                {
                                                    this.props.t("season")+" "+(index+1) 
                                                }
                                                {
                                                    //index == 0 || (this.state.selectedTabs && this.state.selectedTabs[season.season_id]) ? 
                                                    //    <span class="material-icons-outlined">keyboard_arrow_up</span>   
                                                       <span className="material-icons-outlined">keyboard_arrow_down</span> 
                                                }
                                            </button>
                                            <button onClick={() => this.setState({season_id_selected:index,addSeasonImage:1,localUpdate:true,season_id_image:season.season_id,isEditImage:season.image ? true : false})}>
                                                {
                                                    this.props.t(!season.image ? "Add Image" : "Edit Image")
                                                }
                                            </button>
                                        </h5>
                                    </div>
                                    : null
                                    }
                                    <div id={`collapse${season.season_id}`} className={`collapse${index == 0 ? " show" : ""}`} aria-labelledby={`heading${season.season_id}`} data-parent="#seasonData">
                                        <div className="season_cnt">
                                            <ul className="season_selection nav justify-content-center">
                                                {
                                                    !this.state.fromCastnCrew ? 
                                                <li className={!this.state.selectedTabs[season.season_id] || this.state.selectedTabs[season.season_id] == "episode" ? "active" : "nav-link"} onClick={() => {this.selectedtab("episode",season.season_id)}}>
                                                    {
                                                        this.props.t("Episodes")
                                                    }
                                                </li>
                                                : null
                                                }
                                                <li className={this.state.selectedTabs && this.state.selectedTabs[season.season_id] == "cast" ? "active" : "nav-link"} onClick={(e) => {this.selectedtab("cast",season.season_id)}}>
                                                    {
                                                        this.props.t("Regular Cast")
                                                    }
                                                </li>
                                                <li className={this.state.selectedTabs && this.state.selectedTabs[season.season_id] == "crew" ? "active" : "nav-link"} onClick={(e) => {this.selectedtab("crew",season.season_id)}}>
                                                    {
                                                        this.props.t("Regular Crew")
                                                    }
                                                </li>
                                            </ul>
                                        </div>
                                        <div className="card-body">
                                            {
                                                !this.state.selectedTabs[season.season_id] || this.state.selectedTabs[season.season_id] == "episode" ? 
                                                
                                                        <div className="container">
                                                            <div className="row">
                                                                <div className="col-md-12">    
                                                                <button className="add_episode" onClick={this.addEpisode.bind(this,season.season_id)}>
                                                                    {
                                                                        this.props.t("Add Episode")
                                                                    }
                                                                </button>        
                                                                {
                                                                    season.episodes && season.episodes.length > 0 ?

                                                                    <div className="table-responsive">
                                                                        <table className="table custTble1">
                                                                            <thead>
                                                                                <tr>
                                                                                    <th scope="col">{this.props.t("Name")}</th>
                                                                                    <th scope="col">{this.props.t("Number")}</th>
                                                                                    <th scope="col">{this.props.t("Release Date")}</th>
                                                                                    <th scope="col">{this.props.t("Options")}</th>
                                                                                </tr>
                                                                            </thead>
                                                                            <tbody>
                                                                                {
                                                                                    season.episodes.map((episode,index) => {
                                                                                        return (
                                                                                                <tr key={episode.episode_id}>
                                                                                                    <td className="center-img-txt">
                                                                                                        <React.Fragment>
                                                                                                            <Image height="35" width="35" className="cast_crew_listing_img" image={episode.image} title={""} imageSuffix={this.props.pageData.imageSuffix}  siteURL={this.props.pageData.siteURL}/>
                                                                                                            {episode.title}
                                                                                                        </React.Fragment>
                                                                                                    </td>
                                                                                                    <td>{episode.episode_number}</td>
                                                                                                    <td>{episode.release_date}</td>
                                                                                                    <td>
                                                                                                        <div className="actionBtn">
                                                                                                            <a className="text-danger" href="#" title={Translate(this.props, "Delete")} onClick={this.deleteEpisode.bind(this, episode.episode_id)}><span className="material-icons" data-icon="delete"></span></a>                                                                                           
                                                                                                            <a href="#"  className="text-success" title={Translate(this.props, "Edit")} onClick={this.editEpisode.bind(this, episode.episode_id,season.season_id)}><span className="material-icons" data-icon="edit"></span></a>
                                                                                                        </div>
                                                                                                    </td>
                                                                                                </tr>
                                                                                        )
                                                                                    })
                                                                                }
                                                                            </tbody>
                                                                        </table>
                                                                    </div>
                                                                : null
                                                                }
                                                                </div>
                                                            </div>
                                                        </div>
                                                        
                                                : 
                                                this.state.selectedTabs && this.state.selectedTabs[season.season_id] == "cast" ? 
                                                    <div className="container">
                                                        <div className="row">
                                                            <div className="col-md-12">        
                                                                <button className="add_cast" onClick={this.addCast.bind(this,season.season_id)}>
                                                                    {
                                                                        this.props.t("Add Cast")
                                                                    }
                                                                </button>      
                                                                {
                                                                    season.castncrew && season.castncrew.length > 0 ?                   
                                                                <div className="table-responsive">
                                                                    <table className="table custTble1">
                                                                        <thead>
                                                                            <tr>
                                                                                <th scope="col">{this.props.t("Name")}</th>
                                                                                <th scope="col">{this.props.t("Character")}</th>
                                                                                <th scope="col">{this.props.t("Options")}</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            {
                                                                                season.castncrew.map((castncrew,index) => {
                                                                                    return (
                                                                                        castncrew.character ? 
                                                                                            <tr key={castncrew.cast_crew_id}>
                                                                                                <td className="center-img-txt">
                                                                                                    <React.Fragment>
                                                                                                        <Image height="35" width="35" className="cast_crew_listing_img" image={castncrew.image} title={""} imageSuffix={this.props.pageData.imageSuffix} siteURL={this.props.pageData.siteURL} />
                                                                                                        {castncrew.name}
                                                                                                    </React.Fragment>
                                                                                                </td>
                                                                                                <td>{castncrew.character}</td>
                                                                                                <td>
                                                                                                    <div className="actionBtn">
                                                                                                        <a className="text-danger" href="#" title={Translate(this.props, "Delete")} onClick={this.deleteCast.bind(this, castncrew.cast_crew_id)}><span className="material-icons" data-icon="delete"></span></a>                                                                                           
                                                                                                        <a href="#"  className="text-success" title={Translate(this.props, "Edit")} onClick={this.editCast.bind(this, castncrew.cast_crew_id,season.season_id)}><span className="material-icons" data-icon="edit"></span></a>
                                                                                                    </div>
                                                                                                </td>
                                                                                            </tr>
                                                                                        : null
                                                                                    )
                                                                                })
                                                                            }
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                            : null
                                                            }
                                                            </div>
                                                        </div>
                                                    </div>
                                                :
                                                <div className="container">
                                                    <div className="row">
                                                        <div className="col-md-12">       
                                                            <button className="add_crew" onClick={this.addCrew.bind(this,season.season_id)}>
                                                                    {
                                                                        this.props.t("Add Crew")
                                                                    }
                                                            </button>       
                                                            {
                                                                season.castncrew && season.castncrew.length > 0 ?    
                                                                <div className="table-responsive">
                                                                    <table className="table custTble1">
                                                                        <thead>
                                                                            <tr>
                                                                                <th scope="col">{this.props.t("Name")}</th>
                                                                                <th scope="col">{this.props.t("Department")}</th>
                                                                                <th scope="col">{this.props.t("Job")}</th>
                                                                                <th scope="col">{this.props.t("Options")}</th>
                                                                            </tr>
                                                                        </thead>
                                                                        <tbody>
                                                                            {
                                                                                season.castncrew.map((castncrew,index) => {
                                                                                    return (
                                                                                        !castncrew.character ? 
                                                                                            <tr key={castncrew.cast_crew_id}>
                                                                                                <td className="center-img-txt">
                                                                                                    <React.Fragment>
                                                                                                        <Image height="35" width="35" className="cast_crew_listing_img" image={castncrew.image} title={""} imageSuffix={this.props.pageData.imageSuffix} siteURL={this.props.pageData.siteURL} />
                                                                                                        {castncrew.name}
                                                                                                    </React.Fragment>
                                                                                                </td>
                                                                                                <td>{castncrew.department}</td>
                                                                                                <td>{castncrew.job}</td>
                                                                                                <td>
                                                                                                    <div className="actionBtn">
                                                                                                        <a className="text-danger" href="#" title={Translate(this.props, "Delete")} onClick={this.deleteCrew.bind(this, castncrew.cast_crew_id)}><span className="material-icons" data-icon="delete"></span></a>                                                                                           
                                                                                                        <a href="#"  className="text-success" title={Translate(this.props, "Edit")} onClick={this.editCrew.bind(this, castncrew.cast_crew_id,season.season_id)}><span className="material-icons" data-icon="edit"></span></a>
                                                                                                    </div>
                                                                                                </td>
                                                                                            </tr>
                                                                                        : null
                                                                                    )
                                                                                })
                                                                            }
                                                                        </tbody>
                                                                    </table>
                                                                </div>
                                                        : null
                                                        }
                                                        </div>
                                                    </div>
                                                </div>
                                            }
                                            {
                                                !this.state.fromCastnCrew ? 
                                            <a href="#" className="btn btn-danger btn-sm my-3" onClick={ (e) => this.deleteSeason(season.season_id,e)}>
                                                {this.props.t("Delete")}
                                            </a>
                                            : null
                                            }
                                        </div>
                                    </div>
                                
                                </div>
                            )
                        })
                    }
                    
                    

                </div>
            </React.Fragment>
        )
    
        
    }

}


const mapDispatchToProps = dispatch => {
    return {
        openToast: (message, typeMessage) => dispatch(actions.openToast(message, typeMessage))
    };
}
export default connect(null, mapDispatchToProps)(Seasons);