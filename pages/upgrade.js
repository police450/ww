import React from 'react';
import Layout from '../hoc/Layout/Layout';

import * as actions from '../store/actions/general';

import axios from "../axios-site"

import UpgradeView from "../containers/Upgrade/Index"



import { withTranslation } from 'react-i18next';

const Upgrade = (props) => (
  <Layout {...props} >
    <UpgradeView {...props} />
  </Layout>
)

const Extended = withTranslation('common', { wait: typeof window !== 'undefined' })(Upgrade);

Extended.getInitialProps = async function(context) {
    const isServer = !!context.req
    if(isServer){
        const req = context.req
        req.i18n.toJSON = () => null
        const initialI18nStore = {}
        req.i18n.languages.forEach((l) => {
            initialI18nStore[l] = req.i18n.services.resourceStore.data[l];
        })
        
        return {pageData:context.query,initialI18nStore,i18n: req.i18n,initialLanguage: req.i18n.language}
    }else{
      const pageData = await axios.get("/upgrade/?data=1");
      return {pageData:pageData.data.data}
   }
}

export default Extended