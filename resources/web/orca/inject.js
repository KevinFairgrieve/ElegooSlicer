let isWin = false;
console.log('Injecting user script...');
console.log('User agent: ' + navigator.userAgent);
if (navigator.userAgent.indexOf('Windows') !== -1) {
    isWin = true;
    console.log('Windows detected');
}
function hookNativeFunction() {

        document.addEventListener('click', function (event) {
            let target = event.target;
            while (target && target.tagName.toLowerCase() !== 'a') {
                target = target.parentElement;
            }
            if (!target || target.tagName.toLowerCase() !== 'a' || !target.href) {
                return;
            }
            const blank = target.target === '_blank';
            const download = target.getAttribute('download');
            const needDownload = (download !== null) && (download !== undefined);
            if (!blank && !needDownload) {
                return;
            }    
            if (isWin) {
                if(needDownload){
                    return;
                }
                const href = target.href;
                const index = href.indexOf('?');
                if (index !== -1) {
                    href = href.substring(0, index);
                }
                const ext = href.split('.').pop().toLowerCase();
                const exts = ['3mf','stl','obj','gcode','mp3','mp4','jpg','jpeg','png','gif','bmp','avi','mov','mpg','mpeg','wmv','flv','mkv','webm','pdf','doc','docx','xls','xlsx','ppt','pptx','txt','zip','rar','7z','tar','gz','bz'];
                if (exts.includes(ext)) {
                    return;
                }
            }
            console.info('Open URL: ' + target.href);
            event.preventDefault();
            try {
                if (typeof wx !== 'undefined') {
                    wx.postMessage({ cmd: 'open', data: { url: target.href, needDownload: needDownload } });
                } else {
                    console.error('wx is not defined');
                }
            } catch (e) {
                console.error(e);
            }
        });
    
}

function slicerAddButtons() {
    if (window.is_slicer_system_page) {
        console.log('Is slicer system page');
        return;
    }else{
        console.log('Is not slicer system page');
    }
    var style = document.createElement('style');
    style.innerHTML = `
.fixed-buttons {
    position: fixed;
    bottom: 20px;
    right: 20px;
    display: flex;
    flex-direction: column;
    gap: 10px;
    z-index: 9999;
    border: 0px;
}
.fixed-buttons button {
    padding: 0px;
    font-size: 16px;
    background: transparent;
    cursor: pointer;
    transition: transform 0.2s;
    width: 64px;
    height: 64px;
    border: 0px;
}
.fixed-buttons button:hover {
    background-color: transparent;
    transform: scale(1.1); 
}
.fixed-buttons button:active {
    background-color: transparent;
}
@keyframes rotate {
from {
    transform: rotate(0deg);
}
to {
    transform: rotate(360deg);
}
}

.is-loading {
    cursor: wait;
    pointer-events: none;
    animation: rotate 1s linear infinite;
}
`;
    document.head.appendChild(style);
    var buttonContainer = document.createElement('div');
    buttonContainer.className = 'fixed-buttons';

    const svg = '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" fill="none" version="1.1" width="64" height="64" viewBox="0 0 64 64"><g><g><ellipse cx="32" cy="32" rx="32" ry="32" fill="#0C88E0" fill-opacity="1"/></g><g transform="matrix(-1,0,0,-1,106,98)"><path d="M82.6318,74.66669999999999C80.0227,77.05,76.8545,78.33330000000001,73.5,78.33330000000001C66.6045,78.33330000000001,60.82727,73.0167,60.45455,66.2333L61.01364,66.7833C61.38637,67.15,61.75909,67.33330000000001,62.31818,67.33330000000001C62.877269999999996,67.33330000000001,63.25,67.15,63.6227,66.7833C64.3682,66.05,64.3682,64.95,63.6227,64.2167L59.89546,60.55C59.15,59.8167,58.031819999999996,59.8167,57.28636,60.55L53.559091,64.2167C52.813636,64.95,52.813636,66.05,53.559091,66.7833C54.30455,67.5167,55.42273,67.5167,56.16818,66.7833L56.72727,66.2333C57.1,75.0333,64.5545,82,73.5,82C77.7864,82,81.8864,80.35,85.24090000000001,77.2333C85.9864,76.5,85.9864,75.4,85.24090000000001,74.66669999999999C84.6818,73.9333,83.3773,73.9333,82.6318,74.66669999999999ZM93.4409,64.2167C92.69550000000001,63.4833,91.57730000000001,63.4833,90.8318,64.2167L90.2727,64.7667C89.9,55.96667,82.4455,49,73.5,49C69.2136,49,65.1136,50.65,61.75909,53.76667C61.01364,54.5,61.01364,55.6,61.75909,56.333330000000004C62.50455,57.06667,63.6227,57.06667,64.3682,56.333330000000004C66.9773,53.95,70.1455,52.666669999999996,73.5,52.666669999999996C80.3955,52.666669999999996,86.17269999999999,57.98333,86.5455,64.7667L85.9864,64.2167C85.24090000000001,63.4833,84.1227,63.4833,83.3773,64.2167C82.6318,64.95,82.6318,66.05,83.3773,66.7833L87.1045,70.45C87.4773,70.8167,88.0364,71,88.4091,71C88.7818,71,89.3409,70.8167,89.7136,70.45L93.4409,66.7833C94.18639999999999,66.05,94.18639999999999,64.95,93.4409,64.2167Z" fill="#FFFFFF" fill-opacity="1" style="mix-blend-mode:passthrough"/></g></g></svg>';
    var reconnectButton = document.createElement('button');
    reconnectButton.id = 'reconnectButton';
    reconnectButton.innerHTML = svg;
    reconnectButton.addEventListener('click', function () {
        reconnectButton.disabled = true;
        reconnectButton.classList.add('is-loading');
        setTimeout(function () {
            if (typeof wx !== 'undefined') {
                window.is_loading_printer = true;
                wx.postMessage({ cmd: 'reload' });
            } else {
                console.error('wx is not defined');
            }
        }, 500);

    });
    buttonContainer.appendChild(reconnectButton);
    document.body.appendChild(buttonContainer);
}

document.addEventListener('DOMContentLoaded', function () {
    console.log('DOMContentLoaded');
    hookNativeFunction();
    slicerAddButtons();
});