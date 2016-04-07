/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hotelmaster.account.facebook;

import com.github.scribejava.apis.FacebookApi;
import com.github.scribejava.core.builder.ServiceBuilder;
import com.github.scribejava.core.model.*;
import com.github.scribejava.core.oauth.OAuth20Service;
import com.github.scribejava.core.oauth.OAuthService;
import hotelmaster.account.Account;
import hotelmaster.account.AccountFactory;
import hotelmaster.util.ApplicationContextProvider;
import java.util.List;
import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.*;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import static org.springframework.web.context.request.RequestAttributes.*;
import org.springframework.web.context.request.WebRequest;
import org.springframework.web.servlet.ModelAndView;

import org.json.*;
import org.springframework.context.ApplicationContext;
import org.springframework.web.bind.annotation.SessionAttributes;


/**
 *
 * @author Doug
 */
@Controller
public class FacebookController {
        
    private final String ATTR_OAUTH_ACCESS_TOKEN = "ATTR_OAUTH_ACCESS_TOKEN";
    private final String ATTR_OAUTH_REQUEST_TOKEN = "ATTR_OAUTH_REQUEST_TOKEN";
    
    private final String API_KEY = "1529483847357548";
    private final String API_SECRET = "e3cf5bcc041b001fac159ff8a7518108";
    private final String CALLBACK_URL = "http://localhost:8080/facebook-callback"; //this url may change depending on tomcat config (mainly port)
        
    private static final Token EMPTY_TOKEN = null;

    @RequestMapping(value={"/login-facebook"}, method = RequestMethod.GET)
    public ModelAndView login(WebRequest request, HttpServletRequest htrequest) {
        Account accountSession = (Account)htrequest.getSession().getAttribute("accountSession");
        if (accountSession != null) {
            return new ModelAndView("redirect:home");
        }

        // getting request and access token from session
        OAuth2AccessToken  accessToken = (OAuth2AccessToken) null;//request.getAttribute(ATTR_OAUTH_ACCESS_TOKEN, SCOPE_SESSION);
        if(accessToken == null) {
            // generate new request token
            OAuth20Service service = new ServiceBuilder()
                    .apiKey(API_KEY)
                    .apiSecret(API_SECRET)
                    .callback(CALLBACK_URL)
                    .scope("email")
                    .build(FacebookApi.instance());
            
            request.setAttribute(ATTR_OAUTH_REQUEST_TOKEN, EMPTY_TOKEN, SCOPE_SESSION);

            // redirect to facebook auth page
            return new ModelAndView("redirect:" + service.getAuthorizationUrl());
        }
        return new ModelAndView("redirect:loginSuccess");
    }

    @RequestMapping(value={"/facebook-callback"}, method = RequestMethod.GET)
    public ModelAndView callback(@RequestParam(value="code", required=false) String oauthVerifier, WebRequest request, HttpServletRequest htrequest) {
        Account accountSession = (Account)htrequest.getSession().getAttribute("accountSession");
        if (accountSession != null) {
            return new ModelAndView("redirect:home");
        }
        
        ModelAndView modelAndView = new ModelAndView();

        // build the oath service 
        OAuth20Service service = new ServiceBuilder()
                    .apiKey(API_KEY)
                    .apiSecret(API_SECRET)
                    .callback(CALLBACK_URL)
                    .scope("email")
                    .build(FacebookApi.instance());
                
        //OAuthRequest requestToken = (OAuthRequest) request.getAttribute(ATTR_OAUTH_REQUEST_TOKEN, SCOPE_SESSION);

        // getting access token
        OAuth2AccessToken accessToken = service.getAccessToken(oauthVerifier);

        // store access token as a session attribute
        request.setAttribute(ATTR_OAUTH_ACCESS_TOKEN, accessToken, SCOPE_SESSION);

        // getting user profile
        OAuthRequest oauthRequest = new OAuthRequest(Verb.GET, "https://graph.facebook.com/me", service);
        service.signRequest(accessToken, oauthRequest);
        //add the request parameters for various other facebook info:
        oauthRequest.addQuerystringParameter("fields", "id, first_name, last_name, email, gender");
        Response oauthResponse = oauthRequest.send();

        //this is where facebook will throw back a JSON object to form the user object, and update the DB.
        System.out.println("***************************************************");
        System.out.println(oauthResponse.getBody());
        System.out.println("***************************************************");

        JSONObject jobj = new JSONObject(oauthResponse.getBody());

        //we'll assume that if we have an id, the user logged on successfully
        if (!jobj.isNull("id")) {
            try {
                //this will start the DB login flow
                accountSession = new AccountFactory().loginFacebook(jobj);
                
                htrequest.getSession().setAttribute("accountSession", accountSession);
                                                
                System.out.println("facebookController: /facebook-callback accountSession:" + accountSession.toString());
            
            } catch (Exception e){ //todo handle exceptions such as linking
                e.printStackTrace();
            }
        }
        modelAndView.setViewName("redirect:home");
        return modelAndView;
    }
}