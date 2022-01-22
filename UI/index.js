/// <reference path="./src/index.d.ts" />

const APP_NAME = 'TECH-STACK'

document.addEventListener("DOMContentLoaded", () => {
    const node = document.querySelector('#elm-app')
    if (!node) {
        alert("Elm node not found")
    }
    // Get token from local storage
    const token_str = sessionStorage.getItem(`${APP_NAME}_token`) || "";
    const token_json = JSON.parse(token_str)
    const app = Elm.Main.init({
        node: node,
        flags: { os: getOsName(), token: token_json } // { 'token': token_json }
    })
    // app.ports.interopFromElm

    // @ts-ignore
    app.ports.storeTokenData.subscribe(token => {
        sessionStorage.setItem(`${APP_NAME}_token`, JSON.stringify(token));
    })

    // @ts-ignore
    app.ports.logoutUser.subscribe(() => {
        console.log("Logging out user")
        sessionStorage.removeItem(`${APP_NAME}_token`);
    })

})

function getOsName() { // Windows" | "MacOs" | "Linux
    if (window.navigator.userAgent.includes("Windows")) {
        return "Windows"
    } else if (window.navigator.userAgent.includes("Mac")) {
        return "MacOs"
    } else if (window.navigator.userAgent.includes("Linux")) {
        return "Linux"
    }
    return "Mobile/Unknown";
}