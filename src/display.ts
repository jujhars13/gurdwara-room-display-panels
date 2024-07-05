const display = {
    /**
     * Get the content for a particular screen
     * @param googleSheetID the google sheet ID
     * @param screenId the screen ID
     * @returns the content for the screen
     */
    getContent: async (googleSheetID: string, screenId: number) => {
        return {
        screenNumber: 1,
        date: new Date(),
        type: "Akhand Path",
        title: "Preetam Kaur Potato weds Gurvinder Singh Gobi",
        subtitle: "Gobi parivaar",
        misc: "",
        time: "3 days",
        image: ""
        };
    }
};

export {display}