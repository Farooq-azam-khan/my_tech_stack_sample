import './src/index.d.ts'
import { Elm } from './src/Main.elm'
import './tailwind.css'

const APP_NAME = 'TECH-STACK'

document.addEventListener("DOMContentLoaded", () => {
    const node = document.querySelector('#elm-app');
    if (!node) {
        alert("Elm node not found");
    }
    // Get token from local storage
    const token_str = sessionStorage.getItem(`${APP_NAME}_token`);
    const token_json = token_str ? JSON.parse(token_str) : null;
    const app = Elm.Main.init({
        node: node,
        flags: { os: getOsName(), token: token_json }
    })

    app.ports.storeTokenData.subscribe((token: any) => {
        sessionStorage.setItem(`${APP_NAME}_token`, JSON.stringify(token));
    })

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
