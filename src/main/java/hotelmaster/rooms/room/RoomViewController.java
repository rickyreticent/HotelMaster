/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package hotelmaster.rooms.room;

import hotelmaster.Booking;
import hotelmaster.Room;
import hotelmaster.rooms.RoomDAO;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;

/**
 *
 * @author GEORGE
 */
@Controller
@RequestMapping("/rooms")
public class RoomViewController {
    
    @Autowired
    private RoomDAO roomDAO;
    
    @RequestMapping(value="{roomViewURL}", method = RequestMethod.GET)
    public ModelAndView showRoomsDirectory(@PathVariable String roomViewURL){ //@RequestParam("roomViewURL") String URL
        ModelAndView modelAndView = new ModelAndView("roomView");
               
        List<Room> roomList = roomDAO.list();
        
        String URL = roomViewURL;
        System.out.println(URL);
        
        for(int i = 0; i < roomList.size(); i++){
            if(roomList.get(i).getRoomViewURL().equalsIgnoreCase(URL)){
                System.out.println("Found URL: " + roomList.get(i).getRoomViewURL());
                
                //booking
                Booking booking = new Booking();
                modelAndView.addObject("booking", booking);
                
                Room room = new Room();
                int maxGuests = roomList.get(i).getMaxGuests();
                HashMap<String, Integer> numGuests = new HashMap<String, Integer>();
                
                for (int k = 1; k <= maxGuests; k++){
                    numGuests.put(""+k, k);
                }
                
                modelAndView.addObject("numGuests", numGuests);
                modelAndView.addObject("room", roomList.get(i));       
            }
        }
        
        modelAndView.setViewName("roomView");
        
        return modelAndView;
        
    }
//    
//    @RequestMapping(value="{roomViewURL}", method = RequestMethod.POST)
//    public ModelAndView bookRoom(@PathVariable String roomViewURL){
//        ModelAndView modelAndView = new ModelAndView("booking");
//        
//        modelAndView.setViewName("redirect:{roomViewURL}/book");
//        
//        return modelAndView;
//    }
    
}
