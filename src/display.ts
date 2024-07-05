import Papa from "papaparse";

const display = {
  /**
   * Get the content for a particular screen
   * @param googleSheetId the google sheet ID
   * @param screenId the screen ID
   * @returns the content for the screen
   */
  getContent: async (googleSheetId: string, screenId: number) => {
    const rawSheet = await fetch(
      `https://docs.google.com/spreadsheets/d/e/${googleSheetId}/pub?gid=0&single=true&output=csv`
    );
    const rawCSV = await rawSheet.text();
    const csvData = Papa.parse(rawCSV, { header: true });
    return csvData.data.filter(
      (row: any) => parseInt(row.screenNumber) === screenId
    )[0];
  }
};

export { display };
