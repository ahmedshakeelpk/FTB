//
//  PrifleUpdate.swift
//  First Touch Banking
//
//  Created by Syed Uzair Ahmed on 10/07/2018.
//  Copyright © 2018 Syed Uzair Ahmed. All rights reserved.
//

import Foundation
import ObjectMapper


class PrifleUpdate: Mappable {
    
    var accountNumbers: [SingleAccountNumber]?
    var response: Int?
    var message:String?
    var customer_no : String?
    var customer_type : String?
    var customer_name1 : String?
    var current_add_line1 : String?
    var current_add_line2 : String?
    var current_add_line3 : String?
    var current_add_line4 : String?
    var country : String?
    var short_name : String?
    var nationality : String?
    var language : String?
    var exposure_country : String?
    var local_branch : String?
    var liability_no : String?
    var unique_id_name : String?
    var unique_id_value : String?
    var frozen : String?
    var deceased : String?
    var whereabouts_unknown : String?
    var customer_category : String?
    var record_stat : String?
    var auth_stat : String?
    var mod_no : Int?
    var maker_id : String?
    var maker_dt_stamp : String?
    var checker_id : String?
    var checker_dt_stamp : String?
    var once_auth : String?
    var fx_cust_clean_risk_limit : Int?
    var overall_limit : Int?
    var fx_clean_risk_limit : Int?
    var revision_date : String?
    var limit_ccy : String?
    var cas_cust : String?
    var liab_node : String?
    var sec_cust_clean_risk_limit : Int?
    var sec_clean_risk_limit : Int?
    var sec_cust_pstl_risk_limit : Int?
    var sec_pstl_risk_limit : Int?
    var liab_br : String?
    var past_due_flag : String?
    var default_media : String?
    var short_name2 : String?
    var utility_provider : String?
    var full_name : String?
    var aml_required : String?
    var mailers_required : String?
    var cif_status_since : String?
    var chk_digit_valid_reqd : String?
    var ft_accting_as_of : String?
    var unadvised : String?
    var tax_group : String?
    var consol_tax_cert_reqd : String?
    var individual_tax_cert_reqd : String?
    var cls_ccy_allowed : String?
    var cls_participant : String?
    var fx_netting_customer : String?
    var crm_customer : String?
    var issuer_customer : String?
    var treasury_customer : String?
    var cif_creation_date : String?
    var wht_pct : Int?
    var rp_customer : String?
    var generate_mt920 : String?
    var kyc_details : String?
    var staff : String?
    var jv_limit_tracking : String?
    var private_customer : String?
    var lc_collateral_pct : Int?
    var elcm_customer : String?
    var auto_create_account : String?
    var track_limits : String?
    var ar_ap_tracking : String?
    var mfi_customer : String?
    var invest_cust : String?
    var allow_vrtl_accnts : String?
    var mobile_number : String?
    var email : String?
    var perm_add_line1 : String?
    var perm_add_line2 : String?
    var perm_add_line3 : String?
    var corres_add_line1 : String?
    var corres_add_line2 : String?
    var corres_add_line3 : String?
    var marital_status : String?
    var mobile_number_for_OTP : String?
    var country_of_birth : String?
    var country_of_stay : String?
    var country_of_tax_residence : String?
    
    
    required init?(map: Map){ }
    
    func mapping(map: Map) {
        
        accountNumbers <- map["data.accounts"]
        response <- map["response"]
        message <- map["message"]
        customer_no <- map["data.customer_no"]
        customer_type <- map["data.customer_type"]
        customer_name1 <- map["data.customer_name1"]
        current_add_line1 <- map["data.current_add_line1"]
        current_add_line2 <- map["data.current_add_line2"]
        current_add_line3 <- map["data.current_add_line3"]
        current_add_line4 <- map["data.current_add_line4"]
        country <- map["data.country"]
        short_name <- map["data.short_name"]
        nationality <- map["data.nationality"]
        language <- map["data.language"]
        exposure_country <- map["data.exposure_country"]
        local_branch <- map["data.local_branch"]
        liability_no <- map["data.liability_no"]
        unique_id_name <- map["data.unique_id_name"]
        unique_id_value <- map["data.unique_id_value"]
        frozen <- map["data.frozen"]
        deceased <- map["data.deceased"]
        whereabouts_unknown <- map["data.whereabouts_unknown"]
        customer_category <- map["data.customer_category"]
        record_stat <- map["data.record_stat"]
        auth_stat <- map["data.auth_stat"]
        mod_no <- map["data.mod_no"]
        maker_id <- map["data.maker_id"]
        maker_dt_stamp <- map["data.maker_dt_stamp"]
        checker_id <- map["data.checker_id"]
        checker_dt_stamp <- map["data.checker_dt_stamp"]
        once_auth <- map["data.once_auth"]
        fx_cust_clean_risk_limit <- map["data.fx_cust_clean_risk_limit"]
        overall_limit <- map["data.overall_limit"]
        fx_clean_risk_limit <- map["data.fx_clean_risk_limit"]
        revision_date <- map["data.revision_date"]
        limit_ccy <- map["data.limit_ccy"]
        cas_cust <- map["data.cas_cust"]
        liab_node <- map["data.liab_node"]
        sec_cust_clean_risk_limit <- map["data.sec_cust_clean_risk_limit"]
        sec_clean_risk_limit <- map["data.sec_clean_risk_limit"]
        sec_cust_pstl_risk_limit <- map["data.sec_cust_pstl_risk_limit"]
        sec_pstl_risk_limit <- map["data.sec_pstl_risk_limit"]
        liab_br <- map["data.liab_br"]
        past_due_flag <- map["data.past_due_flag"]
        default_media <- map["data.default_media"]
        short_name2 <- map["data.short_name2"]
        utility_provider <- map["data.utility_provider"]
        full_name <- map["data.full_name"]
        aml_required <- map["data.aml_required"]
        mailers_required <- map["data.mailers_required"]
        cif_status_since <- map["data.cif_status_since"]
        chk_digit_valid_reqd <- map["data.chk_digit_valid_reqd"]
        ft_accting_as_of <- map["data.ft_accting_as_of"]
        unadvised <- map["data.unadvised"]
        tax_group <- map["data.tax_group"]
        consol_tax_cert_reqd <- map["data.consol_tax_cert_reqd"]
        individual_tax_cert_reqd <- map["data.individual_tax_cert_reqd"]
        cls_ccy_allowed <- map["data.cls_ccy_allowed"]
        cls_participant <- map["data.cls_participant"]
        fx_netting_customer <- map["data.fx_netting_customer"]
        crm_customer <- map["data.crm_customer"]
        issuer_customer <- map["data.issuer_customer"]
        treasury_customer <- map["data.treasury_customer"]
        cif_creation_date <- map["data.cif_creation_date"]
        wht_pct <- map["data.wht_pct"]
        rp_customer <- map["data.rp_customer"]
        generate_mt920 <- map["data.generate_mt920"]
        kyc_details <- map["data.kyc_details"]
        staff <- map["data.staff"]
        jv_limit_tracking <- map["data.jv_limit_tracking"]
        private_customer <- map["data.private_customer"]
        lc_collateral_pct <- map["data.lc_collateral_pct"]
        elcm_customer <- map["data.elcm_customer"]
        auto_create_account <- map["data.auto_create_account"]
        track_limits <- map["data.track_limits"]
        ar_ap_tracking <- map["data.ar_ap_tracking"]
        mfi_customer <- map["data.mfi_customer"]
        invest_cust <- map["data.invest_cust"]
        allow_vrtl_accnts <- map["data.allow_vrtl_accnts"]
        mobile_number <- map["data.mobile_number"]
        email <- map["data.email"]
        perm_add_line1 <- map["data.perm_add_line1"]
        perm_add_line2 <- map["data.perm_add_line2"]
        perm_add_line3 <- map["data.perm_add_line3"]
        corres_add_line1 <- map["data.corres_add_line1"]
        corres_add_line2 <- map["data.corres_add_line2"]
        corres_add_line3 <- map["data.corres_add_line3"]
        marital_status <- map["data.marital_status"]
        mobile_number_for_OTP <- map["data.mobile_number_for_OTP"]
        country_of_birth <- map["data.country_of_birth"]
        country_of_stay <- map["data.country_of_stay"]
        country_of_tax_residence <- map["data.country_of_tax_residence"]

        
        
        
    }
}


class SingleAccountNumber : Mappable {
    
    var account_class : String?
    var account_number : String?
    var branch_code : String?
    var user_id : String?
    var source_of_funds : String?
    var purpose_of_funds : Double?
    
    required init?(map: Map){ }
    
    func mapping(map: Map){
        
        account_class <- map["account_class"]
        account_number <- map ["account_number"]
        branch_code <- map ["branch_code"]
        user_id <- map ["user_id"]
        source_of_funds <- map ["source_of_funds"]
        purpose_of_funds <- map ["purpose_of_funds"]
        
        
    }
}
