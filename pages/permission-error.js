import React from 'react';
import Layout from '../hoc/Layout/Layout';
import axios from "../axios-site"
import PermissionError from "../containers/Error/PermissionError"

import { withTranslation } from 'react-i18next';

const Index = (props) => (
  <Layout {...props} >     
     <PermissionError {...props} />        
  </Layout>
)

const Extended = withTranslation('common', { wait: typeof window !== 'undefined' })(Index);



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
      const pageData = await axios.get("?data=1");
        return {pageData:pageData.data.data}
   }
}

export default Extended