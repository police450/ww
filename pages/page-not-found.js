import React from 'react';
import Layout from '../hoc/Layout/Layout';

import * as actions from '../store/actions/general';



import { withTranslation } from 'react-i18next';
import PageNotFound from "../containers/Error/PageNotFound"


const Index = (props) => (  
  <Layout {...props} >
    <PageNotFound {...props} />
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
    }
}

export default Extended