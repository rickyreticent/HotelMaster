<%@page import="java.util.Date"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>  

<c:set var="now" value="<%=new java.util.Date()%>" />
<c:set var="tomorrow" value="<%=new Date(new Date().getTime() + 60*60*24*1000)%>"/>
<fmt:formatDate var="currDate" pattern="yyyy-MM-dd" value="${now}" />
<fmt:formatDate var="tmrwDate" pattern="yyyy-MM-dd" value="${tomorrow}"/>

<script>
    $(document).ready(function() {
        $('.roomAnchor').addClass('active');
    });
</script>

<div id="roomView" class="container sections-group containerCustom">
    
    <div class="row">
        <div class="col-md-12 column ui-sortable">
               
            <div class="page-header">
                <h1><c:out value="${room.getRoomName()}"/></h1>
            </div>            
        </div>
    </div>
    <div class="row">
        <div class="col-sm-4 float-right">
            <form:form modelAttribute="booking" action="${room.getRoomViewURL()}/book" method="POST" enctype="utf8">
                <div class="col-xs-12 no-padding text-center">
                    <h2 class="block-title">
                        Book this room!
                    </h2>
                </div>
                <div class="input-group col-xs-12">
                        <form:label path="numGuests" for="ddlGuests">Number of Guests:</form:label>&nbsp;
                        <form:select name="ddlGuests" path="numGuests" class="form-control selectWidth">
                                <form:options items="${numGuests}" />                        
                        </form:select>
                        <form:errors class="formError" path="numGuests" element="strong"/>
                </div> 
                <span class="help-block"></span>

                <div class="input-group col-xs-12">
                        <form:label path="startDate">Check In:</form:label>
                        <form:input path="startDate" placeholder="Check-in Date" value="${currDate}" min="${currDate}" type="date" class="form-control" />
                        <form:errors class="formError" path="startDate" element="strong"/>
                </div>
                <span class="help-block"></span>
                <div class="input-group col-xs-12">
                        <form:label path="endDate">Check Out:</form:label>
                        <form:input path="endDate" placeholder="Check-out Date" value="${tmrwDate}" min="${tmrwDate}" type="date" class="form-control" />
                        <form:errors class="formError" path="endDate" element="strong"/>     
                </div>
                <span class="help-block"></span>

                <div class="col-xs-12 no-padding">
                    <button class="btn btn-primary btn-lg" type="submit">Book Now</button>
                    <br/>
                </div>
                <form:input path="bookingDate" value="${currDate}" type="date" class="hidden" />
                <form:input path="roomID" value="${room.getRoomID()}" class="hidden" />
            </form:form>
            
        </div>
        <div class="col-sm-8">             
            <div id="myCarousel" class="carousel slide room-photo"  data-ride="carousel">
                <!-- Indicators -->
                <ol class="carousel-indicators">
                    <c:forEach var="image" items="${photoList}" varStatus="loop">
                        <c:if test="${photoList.size() > 1}">
                            <li data-target="#myCarousel" data-slide-to="${loop.index}"
                            <c:choose>
                                <c:when test="${loop.index == 0}">
                                    class="active"
                                </c:when>   
                            </c:choose>
                            ></li>
                        </c:if>
                    </c:forEach>
                </ol>

                <!-- Wrapper for slides -->
                <div class="carousel-inner" role="listbox">
                    <c:forEach var="image" items="${photoList}" varStatus="loop">
                        <c:if test="${image.roomID == room.roomID}">
                        <div class="item 
                        <c:choose>
                            <c:when test="${loop.index == 0}">
                                active
                            </c:when>
                        </c:choose>
                        ">
                            <img class="img-responsive" src="/getPhoto?ID=${image.imageID}" alt="Hotel Room Image">
                        </div>
                        </c:if>
                    </c:forEach>
                </div>
            </div>                        
        </div>
    </div>
            <div class="row container-fluid">
             <div class="room-content-title">
                 <br/>
                 <h4>Super cozy <u><c:out value="${room.getRoomName()}"/></u> for just $<strong><c:out value="${room.getPricePerNight()}"/> per night</strong></h4>
             </div>
             
             <div class="room-info">
                 <ul class="feature-list list-unstyled">
                     <c:forEach var="feature" items="${room.features}">
                        <c:choose>
                            <c:when test="${feature.value}">
                                <li><i class="fa fa-check"></i>${feature.key}</li>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    <li><i class="fa fa-check"></i>Max <strong><c:out value="${room.getMaxGuests()}"/></strong> guests</li>
                 </ul>
             </div>
             
             <div class="room-description">
                 <p>One morning, when Gregor Samsa woke from troubled dreams, he found himself transformed in his bed into a horrible vermin. 
                    He lay on his armour-like back, and if he lifted his head a little he could see his brown belly, 
                    slightly domed and divided by arches into stiff sections.</p>

                <p>The bedding was hardly able to cover it and seemed ready to slide off any moment. 
                    His many legs, pitifully thin compared with the size of the rest of him, waved about helplessly as he looked. 
                    "What's happened to me? " he thought. It wasn't a dream.</p>

                <p>His room, a proper human room although a little too small, lay peacefully between its four familiar walls. 
                    A collection of textile samples lay spread out on the table - 
                    Samsa was a travelling salesman - and above it there hung a picture that he had recently cut out of 
                    an illustrated magazine and housed in a nice, gilded frame. It showed a lady fitted out with a fur hat 
                    and fur boa who sat upright, raising a heavy fur muff that covered the whole of her lower arm towards the viewer. 
                    Gregor then turned to look out the window at the dull weather. Drops</p>
             </div>    
             
        </div>
    </div>