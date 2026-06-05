// Origin Docs — Main JS
// Minimal interactivity for the documentation site

document.addEventListener("DOMContentLoaded", () => {
    
    // 1. Define your phrase configurations
    const phraseSets = {
        main: [
            "The ORIGIN of intelligent control.",
            "Built for robotics and AI."
        ],
        logOr: [
            "High Performance Backend for Robotics DataStreams",
            "Log Origin",
            "LogOr"
        ]
    };

    // 2. Select which set you want to use for this page
    // Change "main" to "logOr" to instantly swap the phrase lists!
    const selectedSet = "main"; 
    const phrases = phraseSets[selectedSet] || [];

    const target = document.getElementById("typing-text");
    let phraseIndex = 0;
    let characterIndex = 0;
    let isDeleting = false;
    
    const typeSpeed = 100;    // Speed while typing (ms per letter)
    const eraseSpeed = 50;    // Speed while deleting (ms per letter)
    const delayBetween = 2000; // How long to pause when a full phrase is typed (ms)

    function handleTyping() {
        // Safety check to ensure phrases exist
        if (phrases.length === 0) return; 
        
        const currentPhrase = phrases[phraseIndex];

        if (!isDeleting) {
            // Typing mode: Add a letter
            target.textContent = currentPhrase.substring(0, characterIndex + 1);
            characterIndex++;

            // Check if phrase is completely typed
            if (characterIndex === currentPhrase.length) {
                isDeleting = true;
                setTimeout(handleTyping, delayBetween); // Pause before deleting
                return;
            }
            
            setTimeout(handleTyping, typeSpeed);
        } else {
            // Deleting mode: Remove a letter
            target.textContent = currentPhrase.substring(0, characterIndex - 1);
            characterIndex--;

            // Check if phrase is completely deleted
            if (characterIndex === 0) {
                isDeleting = false;
                // Move to the next phrase, loop back to 0 if at the end
                phraseIndex = (phraseIndex + 1) % phrases.length; 
                setTimeout(handleTyping, 500); // Small pause before typing next phrase
                return;
            }
            
            setTimeout(handleTyping, eraseSpeed);
        }
    }

    // Initialize the typing loop if element exists on the DOM
    if (target) {
        handleTyping();
    }
});