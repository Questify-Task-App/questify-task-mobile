import { StyleSheet } from "react-native";

export const globalStyles = StyleSheet.create({
  container: {
    flex: 1,
    padding: 10,
  },
  banner: {
    backgroundColor: '#007AFF',
    padding: 10,
    alignItems: 'center',
  },
  bannerText: {
    color: '#fff',
    fontSize: 18,
    fontWeight: 'bold',
  },
  listContainer: {
    flex: 1,
    marginTop: 10,
  },
  input: {
    borderWidth: 1,
    borderColor: '#ccc',
    padding: 10,
    marginBottom: 10,
  },
  item: {
    flexDirection: 'row',
    justifyContent: 'space-between',
    alignItems: 'center',
    padding: 10,
    borderBottomWidth: 1,
    borderBottomColor: '#ccc',
  },
  itemButtons: {
    flexDirection: 'row',
    gap: 10,
  },
  tabBar: {
    backgroundColor: '#fff',
    borderTopColor: '#e0e0e0',
    height: 72,
    paddingVertical: 0,
    marginTop: 0,
    paddingBottom: 8,
  },
});