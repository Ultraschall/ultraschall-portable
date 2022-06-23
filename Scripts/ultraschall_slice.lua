-- @version 1.0
-- @author Udo Sauer
-- @changelog
--   Initial release

-- Avid sytle "Add Edit"
-- Split all selected items at cursor position
-- if no item is selected split all items in selected tracks at cursor position
-- if no track is selected split all items in all tracks at position
-- and do not split locked items!

allow_split_of_locked_items=false --set to true if you need it
mark_right_item_after_split=false --set to true if you prefer the reaper split behavior

function get_position()
    playstate=reaper.GetPlayState() --0 stop, 1 play, 2 pause, 4 rec possible to combine bits
    if playstate==1 or playstate==4 then
        return reaper.GetPlayPosition()
    else
        return reaper.GetCursorPosition()
    end
end

function main()
    reaper.Undo_BeginBlock()
        position=get_position()
        number_of_selected_media_items=reaper.CountSelectedMediaItems(0)
        number_of_tracks=reaper.CountTracks(0)
        number_of_selected_tracks=reaper.CountSelectedTracks(0)
        items_to_split={}
        index=1
        
        if number_of_selected_media_items>0 then
            for i=0,number_of_selected_media_items-1 do
                item=reaper.GetSelectedMediaItem(0, i)
                items_to_split[index]={}
                items_to_split[index].item=item
                index=index+1
            end
        elseif number_of_selected_tracks>0 then
            for i=0, number_of_selected_tracks-1 do
                track=reaper.GetSelectedTrack(0, i)
                number_of_track_items=reaper.GetTrackNumMediaItems(track)
                for m=0, number_of_track_items-1 do
                    item=reaper.GetTrackMediaItem(track,m)
                    media_start=reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                    media_end  =reaper.GetMediaItemInfo_Value(item, "D_LENGTH")+media_start
                    if media_start<position and media_end>position then
                        items_to_split[index]={}
                        items_to_split[index].item=item
                        index=index+1
                    end
                end
            end
        elseif number_of_tracks>0 then
            for i=0,number_of_tracks-1 do
                track=reaper.GetTrack(0,i)
                number_of_track_items=reaper.GetTrackNumMediaItems(track)
                for m=0, number_of_track_items-1 do
                    item=reaper.GetTrackMediaItem(track,m)
                    media_start=reaper.GetMediaItemInfo_Value(item, "D_POSITION")
                    media_end  =reaper.GetMediaItemInfo_Value(item, "D_LENGTH")+media_start
                    if media_start<position and media_end>position then
                        items_to_split[index]={}
                        items_to_split[index].item=item
                        index=index+1
                    end
                end
            end
        end
        
        -- split the items
        for i=index-1,1,- 1 do
            item=items_to_split[i].item
    
            if reaper.GetMediaItemInfo_Value(item, "C_LOCK")&1==0 or allow_split_of_locked_items==true then
                newitem=reaper.SplitMediaItem(item, position)
                if newitem ~=null and mark_right_item_after_split==true then
                    reaper.SetMediaItemSelected(newitem, 1)
                    reaper.SetMediaItemSelected(item, 0)
                end
            end
            reaper.UpdateArrange() --update screen!
        end
    reaper.Undo_EndBlock("Add Edit (fernsehmuell script)", -1)
end

main()
