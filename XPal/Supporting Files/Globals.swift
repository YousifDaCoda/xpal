//
//  Globals.swift
//  PhotosVideos
//
//  Created by Ryan Pini & Osman Balci on 4/1/25.
//  Copyright © 2025 Osman Balci. All rights reserved.
//
//-----------------------------------------
// Global Alert Title and Message Variables
//-----------------------------------------
var alertTitle = ""
var alertMessage = ""

//------------------------
// My Google Translate API Key
//------------------------

let myGoogleTranslateApiKey = "AIzaSyCNddUImoNiIkoklwirN29u972x3YG6jAU"


//------------------------------
// Google Translate API HTTP Headers
//------------------------------
let googleTranslateApiHeaders = [
    "accept": "application/json",  // Indicating that the response will be in JSON format
    "cache-control": "no-cache",   // Prevents caching of the response
    "connection": "keep-alive",    // Keeps the connection alive for multiple requests
    "host": "translation.googleapis.com",  // Host URL for Google Translate API
    "Content-Type": "application/json"  // Ensures data is sent and received in JSON format
]

var englishHighScore = ["english" : "0.0"]
var arabicHighScore = ["arabic" : "0.0"]
var frenchHighScore = ["french" : "0.0"]
var russianHighScore = ["russian" : "0.0"]
var chineseHighScore = ["chinese" : "0.0"]
var spanishHighScore = ["spanish" : "0.0"]


